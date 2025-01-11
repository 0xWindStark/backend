#[starknet::interface]
trait IActions<T> {
    fn start(ref self: T);
    fn move(ref self: T, direction: Direction);
    fn exit(ref self: T);
}

#[dojo::contract]
pub mod actions {
    use super::{IActions};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    // #[derive(Copy, Drop, Serde)]
    // #[dojo::event]
    // pub struct Moved {
        
    // }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn start(ref self: ContractState) {
            
        }

        fn move(ref self: ContractState, direction: Direction) {
            
        }

        fn exit(ref self: ContractState) {
            
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        
    }
}