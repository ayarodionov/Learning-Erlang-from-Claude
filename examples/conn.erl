-module(conn).
-behaviour(gen_statem).

-export([start_link/1, send/2, status/1]).
-export([callback_mode/0, init/1, handle_event/4]).

%% API
start_link(ConnectFun) -> gen_statem:start_link(?MODULE, ConnectFun, []).
send(Pid, Msg)         -> gen_statem:call(Pid, {send, Msg}).
status(Pid)            -> gen_statem:call(Pid, status).

%% Callbacks
callback_mode() -> [handle_event_function, state_enter].

init(ConnectFun) ->
    {ok, connecting, #{connect => ConnectFun, attempt => undefined,
                       retries => 0, sock => undefined}}.

%% --- connecting: one attempt, at most 5 s ---
handle_event(enter, _Old, connecting, #{connect := F} = D) ->
    Self = self(),
    Ref = make_ref(),
    spawn_link(fun() -> Self ! {connect_result, Ref, F()} end),
    {keep_state, D#{attempt := Ref}, [{state_timeout, 5000, give_up}]};
handle_event(info, {connect_result, Ref, {ok, Sock}}, connecting,
             #{attempt := Ref} = D) ->
    {next_state, connected, D#{sock := Sock, retries := 0}};
handle_event(info, {connect_result, Ref, {error, _}}, connecting,
             #{attempt := Ref} = D) ->
    {next_state, backoff, D};
handle_event(state_timeout, give_up, connecting, D) ->
    {next_state, backoff, D};

%% --- backoff: wait, doubling the delay each time ---
handle_event(enter, _Old, backoff, #{retries := N} = D) ->
    Delay = min(30000, 100 bsl N),
    {keep_state, D#{retries := N + 1}, [{state_timeout, Delay, retry}]};
handle_event(state_timeout, retry, backoff, D) ->
    {next_state, connecting, D};

%% --- connected ---
handle_event(enter, _Old, connected, _D) ->
    keep_state_and_data;
handle_event({call, From}, {send, Msg}, connected, #{sock := S}) ->
    {keep_state_and_data, [{reply, From, {sent, S, Msg}}]};
handle_event(info, {closed, S}, connected, #{sock := S} = D) ->
    {next_state, backoff, D#{sock := undefined}};

%% --- any state ---
handle_event({call, From}, status, State, _D) ->
    {keep_state_and_data, [{reply, From, State}]};
handle_event({call, _From}, {send, _}, _NotConnected, _D) ->
    {keep_state_and_data, [postpone]};
handle_event(info, {connect_result, _StaleRef, _}, _State, _D) ->
    keep_state_and_data.
