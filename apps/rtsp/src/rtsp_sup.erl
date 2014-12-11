-module(rtsp_sup).

-behaviour(supervisor).

-export([init/1]).

-export([start_link/0,start_socket/0]).


start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
	{ok, Port} = {ok,8554},
	{ok, ListenSocket} = gen_tcp:listen(Port, [{active,once}, {packet,line}]),
	spawn_link(fun empty_listeners/0),
		{ok, {{simple_one_for_one, 60, 3600},
			[{rtsp_socket_handler,
				{rtsp_connector, start_link, [ListenSocket]}, % module name, function, argument
				temporary,
				1000, 
				worker,
				[rtsp_connector]}
			]
		}}.

start_socket() ->
	supervisor:start_child(?MODULE, []).

empty_listeners() ->
	[start_socket() || _ <- lists:seq(1,20)],
ok.
