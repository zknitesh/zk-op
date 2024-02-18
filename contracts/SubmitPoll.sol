// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./UltraVerifier.sol";

contract SubmitPoll {
    error POLL_REGISTRATION_DUPLICATE();
    error POLL_UNREGISTRATION_USER_NOT_REGISTERED();
    error POLL_REGISTRATION_VERIFICATION_FAILED();
    error POLL_SUBMISSION_FAILED();
    error POLL_ALREADY_EXISTS();
    error INVALID_QUESTION_OR_ANSWER_ID();

    struct PollAnswer {
        uint256 questionId;
        uint256 answerId;
    }

    struct UserPoll {
        string userHash;
        PollAnswer[] answers;
    }

    struct AnswerOption {
        uint256 id;
        string text; // Text description for the answer
    }

    struct Question {
        uint256 id;
        string text; // Text description for the question
        AnswerOption[3] answerOptions; // Array to hold up to 3 answer options
    }

    struct Poll {
        uint256 id;
        Question[] questions;
    }

    uint256 private constant SYSTEM_SECRET = 42;
    uint8 private constant ANSWER_OPTION_COUNT = 3;
    mapping(string => bool) private sPollUsers;
    string[] private sUserHashes; // Array to store user hashes
    mapping(uint256 => UserPoll[]) private pollAnswers;
    mapping(uint256 => Poll) private polls;

    // Later make this a payable method, such that only deployer can register for free
    function registerPoll(string memory userHash) public {
        if (sPollUsers[userHash]) {
            revert POLL_REGISTRATION_DUPLICATE();
        } else {
            sPollUsers[userHash] = true;
            sUserHashes.push(userHash);
        }
    }

    // function processUserHashes() private view returns (bytes32[] memory) {
    //     bytes32[] memory hashesAsBytes32 = new bytes32[](sUserHashes.length);
    //     for (uint i = 0; i < sUserHashes.length; i++) {
    //         // Convert each user hash string to bytes32
    //         hashesAsBytes32[i] = stringToBytes32(sUserHashes[i]);
    //     }
    //     return hashesAsBytes32;
    // }

    // function stringToBytes32(
    //     string memory source
    // ) private pure returns (bytes32 result) {
    //     bytes memory tempEmptyStringTest = bytes(source);
    //     if (tempEmptyStringTest.length == 0) {
    //         return 0x0;
    //     }
    //     assembly {
    //         result := mload(add(source, 32))
    //     }
    // }

    // function unregisterPoll(string memory userHash) public {
    //     if (sPollUsers[userHash]) {
    //         sPollUsers[userHash] = false;
    //     } else {
    //         revert POLL_UNREGISTRATION_USER_NOT_REGISTERED();
    //     }
    // }

    function verify(string memory userHash) public view {
        //,bytes calldata proof) public {
        bytes32[] memory publicInputs = new bytes32[](4);
        publicInputs[0] = bytes32(SYSTEM_SECRET);
        if (!sPollUsers[userHash]) {
            revert POLL_REGISTRATION_VERIFICATION_FAILED();
        }
        // publicInputs[1] = processUserHashes(); // an array of user hashes;
        // UltraVerifier verifier = new UltraVerifier();
        // verifier.verify(proof, publicInputs);
    }

    function submitPollAnswers(
        string memory userHash,
        uint256 pollId,
        uint256[] memory questionIds,
        uint256[] memory answerIds // bytes calldata proof
    ) public {
        // Verify the user's participation and proof
        verify(userHash); // Simplified for demonstration

        // Check if questionIds and answerIds arrays have the same length
        require(questionIds.length == answerIds.length, "INVALID_INPUT_LENGTH");

        // Find or initialize the UserPoll for this userHash and pollId
        // For simplicity in this example, we assume a new UserPoll is always created
        // This might need adjustment based on your application's logic
        uint userPollIndex = pollAnswers[pollId].length; // Index where the new UserPoll will be inserted
        pollAnswers[pollId].push(); // Expand the array to make room for a new UserPoll
        UserPoll storage userPoll = pollAnswers[pollId][userPollIndex];
        userPoll.userHash = userHash; // Set the userHash for this UserPoll

        // Now, manually push each PollAnswer to the UserPoll.answers storage array
        for (uint256 i = 0; i < questionIds.length; i++) {
            userPoll.answers.push(
                PollAnswer({questionId: questionIds[i], answerId: answerIds[i]})
            );
        }
    }

    function getPollAnswers(
        uint256 pollId
    ) public view returns (UserPoll[] memory) {
        return pollAnswers[pollId];
    }

    function getPollResults(
        uint256 pollId
    )
        public
        view
        returns (uint256[] memory questionIds, uint256[][] memory answerCounts)
    {
        // Determine the size of the result set
        uint256 questionCount = 0; // You need to define how to get this, could be a parameter
        for (uint256 i = 0; i < pollAnswers[pollId].length; i++) {
            uint256 answersLength = pollAnswers[pollId][i].answers.length;
            if (answersLength > questionCount) {
                questionCount = answersLength;
            }
        }

        // Initialize return arrays
        questionIds = new uint256[](questionCount);
        answerCounts = new uint256[][](questionCount);
        for (uint256 i = 0; i < questionCount; i++) {
            // Assuming each question can have 4 possible answers (1-4), adjust as needed
            answerCounts[i] = new uint256[](4); // Adjust the size based on your maximum answerId
        }

        // Aggregate the results
        for (uint256 i = 0; i < pollAnswers[pollId].length; i++) {
            for (
                uint256 j = 0;
                j < pollAnswers[pollId][i].answers.length;
                j++
            ) {
                uint256 questionId = pollAnswers[pollId][i]
                    .answers[j]
                    .questionId;
                uint256 answerId = pollAnswers[pollId][i].answers[j].answerId;

                // Increment the count for this answer
                // This assumes answerId starts at 1 and goes up to the size of answerCounts[questionId]
                if (answerId > 0 && answerId <= answerCounts[j].length) {
                    answerCounts[j][answerId - 1] += 1; // Adjust index by -1 since arrays are 0-indexed
                }

                // Assuming questionIds are sequential and start from 1, adjust as needed
                questionIds[j] = questionId;
            }
        }

        return (questionIds, answerCounts);
    }

    function registerPoll(
        uint256 pollId,
        string[] memory questionTexts,
        string[][3] memory answerTexts // Each question has up to 5 answer texts
    ) public {
        if (polls[pollId].id != 0) {
            revert POLL_ALREADY_EXISTS();
        }

        Poll storage poll = polls[pollId];
        poll.id = pollId;

        for (uint256 i = 0; i < questionTexts.length; i++) {
            // Temporarily create a new question in storage directly
            Question storage newQuestion = poll.questions.push();
            newQuestion.id = i + 1; // Assuming sequential IDs starting from 1
            newQuestion.text = questionTexts[i];

            for (uint256 j = 0; j < 3; j++) {
                // Manually copy each AnswerOption if it exists
                if (
                    j < answerTexts[i].length &&
                    bytes(answerTexts[i][j]).length > 0
                ) {
                    newQuestion.answerOptions[j].id = j + 1; // Answer IDs are sequential, starting from 1
                    newQuestion.answerOptions[j].text = answerTexts[i][j];
                } else {
                    // If no answer text is provided, set ID to 0 to indicate an unused option
                    newQuestion.answerOptions[j].id = 0;
                    newQuestion.answerOptions[j].text = "";
                }
            }
        }
    }

    // Function to retrieve questions for a given poll
    function getPollQuestions(
        uint256 pollId
    ) public view returns (Question[] memory) {
        return polls[pollId].questions;
    }
}
// ["What is your favorite color?", "What is your preferred pet?", "Which cuisine do you prefer?"]
//[["Red", "Green", "Blue"], ["Dog", "Cat", "Bird"], ["Italian", "Mexican", "Japanese"]]
