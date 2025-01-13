#[starknet::interface]
trait IEndAction<T> {
    fn end(ref self: T);
}

#[dojo::contract]
mod end_action {
    use super::IEndAction;
    use starknet::{ContractAddress, get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, enemy::Enemy, player_position::PlayerPosition, scene::Scene
    }

    #[abi(embed_v0)]
    impl EndActionImpl of IEndAction<ContractState> {
        fn end(ref self: ContractState) {
            
        }
    }
}