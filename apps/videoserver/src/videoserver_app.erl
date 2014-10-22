-module(videoserver_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    io:fwrite("hello, world\n"),
    videoserver_sup:start_link().

stop(_State) ->
    ok.
