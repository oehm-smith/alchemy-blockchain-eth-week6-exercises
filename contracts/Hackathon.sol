// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Hackathon {
    struct Project {
        string title;
        uint[] ratings;
    }

    Project[] projects;

    constructor(){

    }

    // TODO: add the findWinner function

    function newProject(string calldata _title) external {
        // creates a new project with a title and an empty ratings array
        projects.push(Project(_title, new uint[](0)));
    }

    function rate(uint _idx, uint _rating) external {
        // rates a project by its index
        projects[_idx].ratings.push(_rating);
    }

    function findWinner() external view returns (Project memory) {
        uint ongoingWinner = 0;
        uint ongoingWinnerAv = 0;
        for (uint p = 0; p < projects.length; ++p) {
            Project memory a = projects[p];
            uint sum = 0;
            uint len = a.ratings.length;
            for (uint r = 0; r < len; ++r) {
                sum += a.ratings[r];
            }
            uint av = sum / a.ratings.length;
            console.log("Project: %s, sum: %s, av: %s", p, sum, av);
//            console.log("Project: %s, sum: %s, ratings: %s, av: %s", p, 5, 7, 3);
            if (av > ongoingWinnerAv) {
                ongoingWinner = p;
                ongoingWinnerAv = av;
            }
        }
        Project memory retProject = projects[ongoingWinner];
        return retProject;
    }
}
