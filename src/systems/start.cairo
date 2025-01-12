#[dojo::interface]
trait IStartAction {
    fn start(ref world: IWorldDispatcher);
}

#[dojo::contract]
mod start_action {
    use super::IStartAction;
    use starknet::{ContractAddress, get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, enemy::Enemy, player_position::PlayerPosition, scene::Scene
    }

    use cartridge_vrf::IVrfProviderDispatcher;
    use cartridge_vrf::IVrfProviderDispatcherTrait;
    use cartridge_vrf::Source;

    const WIDTH: u32 = 100;
    const HEIGHT: u32 = 100;
    const ROOM_COUNT: u32 = 20;
    const MIN_ROOM_SIZE: u32 = 7;
    const MAX_ROOM_SIZE: u32 = 15;
    const CORRIDOR_WIDTH: u32 = 4;
    const BASE_ENEMY_COUNT: u32 = 5;
    const ENEMY_INCREASE_RATE: f32 = 20;
    const VRF_PROVIDER_ADDRESS: starknet::ContractAddress = 0x051fea4450da9d6aee758bdeba88b2f665bcbf549d2c61421aa724e9ac0ced8f.try_into().unwrap();

    #[abi(embed_v0)]
    impl StartActionImpl of IStartAction<ContractState> {
        fn start(ref world: IWorldDispatcher) {
            let vrf_provider = IVrfProviderDispatcher { contract_address: VRF_PROVIDER_ADDRESS };
            let player = get_caller_address();

            let old_scene: Scene = get!(world, player, (Scene));

            let new_level = old_scene.level + 1;

            set!(
                world,
                (Scene {
                    player,
                    level: new_level,
                    map: old_scene.map
                })
            )
        }
    }
}