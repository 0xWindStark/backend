#[starknet::interface]
trait IMoveAction<T> {
    fn move(ref self: T, direction: u8);
}

#[dojo::contract]
mod move_action {
    use super::IMoveAction;
    use starknet::{ContractAddress, get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, directions::Directions, enemy::Enemy, player_position::PlayerPosition, player_state::PlayerState, scene::Scene, trail::Trail
    }

    #[abi(embed_v0)]
    impl MoveActionImpl of IMoveAction<ContractState> {
        fn move(ref self: ContractState, direction: u8) {
            
        }
    }
}