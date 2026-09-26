%% Chapter 3: which binary slices keep a 10 MB parent alive (run on OTP 25).
%% erlc binary_slices.erl && erl -noshell -eval 'binary_slices:run(), halt().'
-module(binary_slices).
-export([run/0]).
run() ->
    Big = binary:copy(<<1>>, 10000000),
    <<_:32/binary, S16:16/binary, _/binary>> = Big,
    <<_:32/binary, S64:64/binary, _/binary>> = Big,
    <<_:32/binary, S65:65/binary, _/binary>> = Big,
    <<_:32/binary, S200:200/binary, _/binary>> = Big,
    P16 = binary:part(Big, 32, 16),
    P200 = binary:part(Big, 32, 200),
    [io:format("~-28s refs ~p bytes~n", [N, binary:referenced_byte_size(B)])
     || {N, B} <- [{"match 16 bytes", S16}, {"match 64 bytes", S64}, {"match 65 bytes", S65},
                   {"match 200 bytes", S200}, {"binary:part 16 bytes", P16}, {"binary:part 200 bytes", P200}]],
    ok.
