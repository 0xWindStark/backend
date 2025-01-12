use starknet::ContractAddress;
use starknet::storage::Map;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Scene {
    #[key]
    pub player: ContractAddress,
    level: u8,
    pub map: Map<u8, Map<u8, u8>>,
}