#[starknet::interface]
trait IStartAction<T> {
    fn start(ref self: T);
}

#[dojo::contract]
mod start_action {
    use super::IStartAction;
    use starknet::{ContractAddress, get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, enemy::Enemy, player_position::PlayerPosition, scene::Scene
    }
    use origami_map::map::MapTrait;

    const SIDE: u32 = 15;
    const BASE_ENEMY_COUNT: u32 = 5;
    const ENEMY_INCREASE_RATE: f32 = 20;

    #[abi(embed_v0)]
    impl StartActionImpl of IStartAction<ContractState> {
        fn start(ref self: ContractState) {
            // step 1: create scene

            let mut world = self.world_default();
            let player = get_caller_address();

            let mut map = MapTrait::new_maze(SIDE, SIDE, 0, 'REWIND');
            // let postion = 1;
            // let order = 0;
            // map.open_with_corridor(postion, order);

            let old_scene: Scene = world.read_model(player);

            let new_scene = Scene {
                player,
                level: old_scene.level + 1,
                map: map.grid,
            };

            world.write_model(@new_scene);

            // step 2: spawn player on bottom-left most 1 path

            for i in 1..13_u32 {
                for j in 1..13_u32 {
                    let x: u32 = 14 - i;
                    let y: u32 = j;

                    let index = y * SIDE + x;

                    let mut pos: u256 = 1;
                    for a in 0..index {
                        pos = pos * 2;
                    }

                    let grid_u256: u256 = map.grid.into();

                    if (grid_u256 & pos) != 0 && (grid_u256 & pos) == pos {
                        let small_pos = Coordinates {
                            x: 1,
                            y: 1
                        };

                        let big_pos = Coordinates {
                            x,
                            y
                        };

                        let pos = Coordinates {
                            x: x * 3 + 1,
                            y: y * 3 + 1
                        };

                        let player_position = PlayerPosition {
                            player,
                            small_pos,
                            big_pos,
                            pos
                        };

                        world.write_model(@player_position);
                        break;
                    }
                }
            }

            //step 3: create level clear corridor

            for i in 1..13_u32 {
                for j in 1...13_u32 {
                    let x: u32 = i;
                    let y: u32 = 14 - j;

                    let index = y * SIDE + x;

                    let mut pos: u256 = 1;
                    for a in 0..index {
                        pos = pos * 2;
                    }

                    let grid_u256: u256 = map.grid.into();

                    if (grid_u256 & pos) != 0 && (grid_u256 & pos) == pos {
                        let corridor = CorridorPosition {
                            player,
                            pos: Coordinates {
                                x: x + 1,
                                y: y + 1
                            }
                        };

                        world.write_model(@corridor);
                        break;
                    }
                }
            }
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"windstark");
        }
    }
}