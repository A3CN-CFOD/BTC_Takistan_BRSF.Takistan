class CfgFunctions
{
			class A3CN
			{
			tag = "A3CN";

				class common {
					file = "a3cn\common";
					class tracker {description = "mostra onde o ponto está";};
					class mark_local {description = "mark2";};
					class mark_global {description = "mark";};
					class mark_point {description = "marca o ponto";};
					class timer{};
				};
				class transport {
					file = "a3cn\transport";
					class init_transport {description = "init transport option";};
					class dest_transport {description = "transport destination";};
					class rtb_transport {description = "transport rtb";};
					class mappos {description = "gets pos from mapclick";};
					class transportserver {description = "server function for airlift";};
					class init_airlift {description = "init airlift option";};
					class airliftserver {description = "server function for airlift";};
				};
				class gunship
				{
					file = "a3cn\gunship";
					class gunship {description = "Gunship Support";};
					class dest_gunship {description = "set new position for gunship";};
				};


			};
};
