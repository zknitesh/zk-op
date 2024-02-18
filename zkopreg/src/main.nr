use dep::std;

fn main(userAadharNumber: Field, 
        userSecret: Field,
        systemSecret: Field) -> pub Field {
    let userIdentifierHash = registerForPoll(userAadharNumber, userSecret, systemSecret);
    // std::println("userIdentifierHash");
    // std::println(userIdentifierHash);
    userIdentifierHash
}

fn registerForPoll(userAadharNumber: Field, 
                   userSecret: Field,
                   systemSecret: Field) -> Field {
    let userIdentifierHash = std::hash::pedersen_hash([userAadharNumber, userSecret, systemSecret]);
    std::println("userIdentifierHash");
    std::println(userIdentifierHash);
    assert(userIdentifierHash != 0);
    userIdentifierHash
}

#[test]
fn test_main() {
    let value = main(1, 2, 42);
    std::println(value);
    // Uncomment to make test fail
    // main(1, 1);
}
