use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Scene {
    #[key]
    pub player: ContractAddress,
    pub level: u8,
    pub map: felt252,
}
