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

    #[abi(embed_v0)]
    impl StartActionImpl of IStartAction<ContractState> {
        fn start(ref world: IWorldDispatcher) {
            
        }
    }
}