-module(rtp_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-import(error_logger, [info_msg/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  error_logger:info_msg("Start RTP app"),
  rtp_sup:start_link().

stop(_State) ->
  ok.
