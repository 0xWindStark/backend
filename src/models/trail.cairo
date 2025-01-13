use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Drop, Serde)]
#[dojo::model]
pub struct Trail {
    #[key]
    pub player: ContractAddress,
    pub path: Array<Coordinates>,
}