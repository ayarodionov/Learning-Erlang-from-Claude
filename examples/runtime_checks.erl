%% Spot checks of Erlang book claims (run on OTP 25).
%% erlc runtime_checks.erl && erl -noshell -eval 'runtime_checks:run(), halt().'
-module(runtime_checks).
-export([run/0, init/1, handle_call/3, handle_cast/2]).
-behaviour(gen_server).
init(_) -> {ok, nil}.
handle_call(self_call, _F, S) -> {reply, catch gen_server:call(checks_srv, x, 1000), S};
handle_call(x, _F, S) -> {reply, x, S}.
handle_cast(_, S) -> {noreply, S}.
run() ->
    %% ch2 4.4: send to unregistered name
    io:format("send to unregistered name: ~p~n", [catch (no_such_name ! hello)]),
    %% ch4: ordered_set 1 vs 1.0
    T = ets:new(t, [ordered_set]), ets:insert(T, {1, a}), ets:insert(T, {1.0, b}),
    io:format("ordered_set 1 and 1.0: ~p~n", [ets:tab2list(T)]),
    S = ets:new(s, [set]), ets:insert(S, {1, a}), ets:insert(S, {1.0, b}),
    io:format("set 1 and 1.0: ~p~n", [lists:sort(ets:tab2list(S))]),
    %% ch5: gen_server calling itself
    {ok, _} = gen_server:start({local, checks_srv}, ?MODULE, [], []),
    io:format("gen_server calls itself: ~p~n", [element(1, element(2, gen_server:call(checks_srv, self_call)))]),
    %% ch3: see binary_slices.erl for which slices keep the parent alive
    %% ch2: monitor on dead pid
    Dead = spawn(fun() -> ok end), timer:sleep(10),
    R = monitor(process, Dead),
    receive {'DOWN', R, process, Dead, Why} -> io:format("monitor on dead pid: ~p~n", [Why]) after 100 -> io:format("no DOWN~n") end,
    ok.
