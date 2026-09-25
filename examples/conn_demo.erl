%% Demo for conn.erl (chapter 13).
%% erlc conn.erl conn_demo.erl && erl -noshell -eval 'conn_demo:run(), halt().'
-module(conn_demo).
-export([run/0]).

run() ->
    %% A fake connect function: the first two attempts fail, then it succeeds.
    C = counters:new(1, []),
    Connect = fun() ->
                      counters:add(C, 1, 1),
                      case counters:get(C, 1) of
                          N when N < 3 -> {error, refused};
                          _ -> {ok, sock1}
                      end
              end,
    {ok, P} = conn:start_link(Connect),
    io:format("initial state: ~p~n", [conn:status(P)]),
    T0 = erlang:monotonic_time(millisecond),
    Reply = conn:send(P, hello),              %% postponed until connected
    io:format("send -> ~p after ~p ms (~p attempts), state ~p~n",
              [Reply, erlang:monotonic_time(millisecond) - T0,
               counters:get(C, 1), conn:status(P)]),
    P ! {closed, sock1},                      %% simulate a dropped connection
    timer:sleep(10),
    io:format("after drop: ~p~n", [conn:status(P)]),
    io:format("send -> ~p, state ~p~n", [conn:send(P, again), conn:status(P)]),
    ok.
