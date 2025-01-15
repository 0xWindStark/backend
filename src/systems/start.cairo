#[starknet::interface]
trait IStartAction<T> {
    fn start(ref self: T);
}

#[dojo::contract]
mod start_action {
    use super::IStartAction;
    use starknet::{get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, player_position::PlayerPosition, scene::Scene, corridor::Corridor,
    };
    use origami_map::map::MapTrait;
    use dojo::model::{ModelStorage};

    const SIDE: u8 = 15;
    const BASE_ENEMY_COUNT: u32 = 5;
    const ENEMY_INCREASE_RATE: u32 = 20;

    #[abi(embed_v0)]
    impl StartActionImpl of IStartAction<ContractState> {
        fn start(ref self: ContractState) {
            let mut world = self.world_default();
            let player = get_caller_address();

            let mut map = MapTrait::new_maze(SIDE, SIDE, 0, 'REWIND');

            let old_scene: Scene = world.read_model(player);

            let new_scene = Scene { player, level: old_scene.level + 1, map: map.grid };

            world.write_model(@new_scene);

            let side_u32: u32 = SIDE.into();

            for i in 1..13_u32 {
                for j in 1..13_u32 {
                    let x: u32 = 14 - i;
                    let y: u32 = j;

                    let index = y * side_u32 + x;

                    let mut pos: u256 = 1;
                    for _a in 0..index {
                        pos = pos * 2;
                    };

                    let grid_u256: u256 = map.grid.into();

                    if (grid_u256 & pos) != 0 && (grid_u256 & pos) == pos {
                        let small_pos = Coordinates { x: 2, y: 2 };

                        let big_pos = Coordinates { x, y };

                        let pos = Coordinates { x: (x * 3) + 2, y: (y * 3) + 2 };

                        let player_position = PlayerPosition { player, small_pos, big_pos, pos };

                        world.write_model(@player_position);
                        break;
                    }
                }
            };

            for i in 1..13_u32 {
                for j in 1..13_u32 {
                    let x: u32 = i;
                    let y: u32 = 14 - j;

                    let index = y * side_u32 + x;

                    let mut pos: u256 = 1;
                    for _a in 0..index {
                        pos = pos * 2;
                    };

                    let grid_u256: u256 = map.grid.into();

                    if (grid_u256 & pos) != 0 && (grid_u256 & pos) == pos {
                        let corridor = Corridor { player, pos: Coordinates { x: x + 2, y: y + 2 } };

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
            self.world(@"windstark")
        }
    }
}
