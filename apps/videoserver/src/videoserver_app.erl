-module(videoserver_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-import(error_logger, [format/2,error_msg/1,info_msg/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    videoserver_sup:start_link().

stop(_State) ->
    ok.
