use dep::std;

global MaxParticipantSize = 2;


fn main(userAadharNumber: Field, 
        userSecret: Field,
        systemSecret: pub Field,
        userHashes: pub [Field; MaxParticipantSize]) {
    let userIdentifierHash = std::hash::pedersen_hash([userAadharNumber, userSecret, systemSecret]);
    std::println("userIdentifierHash");
    std::println(userIdentifierHash);
    let any = userHashes.any(|a| a == userIdentifierHash);
    assert(any);
}

fn registerForPoll(userAadharNumber: Field, 
                   userSecret: Field,
                   systemSecret: Field) -> Field {
    let userIdentifierHash = std::hash::pedersen_hash([userAadharNumber, userSecret, systemSecret]);
    userIdentifierHash
}

#[test]
fn test_main() {
    main(1, 2, 42, [1, 2]);
}
