use core::starknet::ContractAddress;

#[starknet::interface]
pub trait IPragmaVRF<TContractState> {
    fn get_last_random_number(self: @TContractState) -> felt252;
    fn request_randomness_from_pragma(
        ref self: TContractState,
        seed: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
        publish_delay: u64,
        num_words: u64,
        calldata: Array<felt252>,
    );
    fn receive_random_words(
        ref self: TContractState,
        requester_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>,
    );
    fn withdraw_extra_fee_fund(ref self: TContractState, receiver: ContractAddress);
}