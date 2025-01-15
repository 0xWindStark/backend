#[starknet::interface]
trait IEndAction<T> {
    fn end(ref self: T);
}

#[dojo::contract]
mod end_action {
    use super::IEndAction;
    use starknet::{get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, enemy::Enemy, player_position::PlayerPosition, scene::Scene,
        corridor::Corridor, player_state::PlayerState, trail::Trail,
    };
    use dojo::model::{ModelStorage};

    #[abi(embed_v0)]
    impl EndActionImpl of IEndAction<ContractState> {
        fn end(ref self: ContractState) {
            let mut world = self.world_default();
            let player = get_caller_address();

            let empty_path: Array<Coordinates> = array![];
            let empty_enemies: Array<felt252> = array![];

            let old_scene: Scene = world.read_model(player);

            let new_corridor = Corridor { player, pos: Coordinates { x: 0, y: 0 } };
            let new_enemy = Enemy { player, enemy_count: 0, enemies: empty_enemies };
            let new_player_position = PlayerPosition {
                player,
                small_pos: Coordinates { x: 0, y: 0 },
                big_pos: Coordinates { x: 0, y: 0 },
                pos: Coordinates { x: 0, y: 0 },
            };
            let new_player_state = PlayerState { player, state: false };
            let new_scene = Scene { player, level: old_scene.level, map: 0 };
            let new_trail = Trail { player, path: empty_path };

            world.write_model(@new_corridor);
            world.write_model(@new_enemy);
            world.write_model(@new_player_position);
            world.write_model(@new_player_state);
            world.write_model(@new_scene);
            world.write_model(@new_trail);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"windstark")
        }
    }
}
