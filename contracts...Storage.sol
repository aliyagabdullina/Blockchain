// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    struct Task {
        string description;
        bool isCompleted;
        uint256 deadline;
        string status;  // completed/in progress/started/not started
    }

    //mapping
    mapping(address => Task[]) public tasks;

    event TaskAdded(address indexed user, string description, bool isCompleted, uint256 deadline, string status);

    // Функция для добавления структуры в отображение
    function addTask(string memory description, uint256 deadline) public {
        Task memory newTask = Task({description: description, isCompleted: false, deadline: deadline, status: "not started"});
        tasks[msg.sender].push(newTask);
        emit TaskAdded(msg.sender, description, false, deadline, "not started");
    }

    event TaskCompleted(address indexed user, uint256 taskIndex);

    //функция для отметки задания сделанным
    function completeTask(uint256 taskIndex) public {
        require(taskIndex < tasks[msg.sender].length, "Invalid task index.");
        tasks[msg.sender][taskIndex].isCompleted = true;
        emit TaskCompleted(msg.sender, taskIndex);
    }

    event TaskRemoved(address indexed user, uint256 taskIndex);

    //функция для удаления задачи
    function removeTask(uint256 taskIndex) public {
        require(taskIndex < tasks[msg.sender].length, "Invalid task index.");
        delete tasks[msg.sender][taskIndex];
        emit TaskRemoved(msg.sender, taskIndex);
    }

    event TaskStatusChanged(address indexed user, uint256 taskIndex, string newStatus);

    // Функция для смены статуса задачи
    function changeTaskStatus(uint256 taskIndex, string memory newStatus) public {
        require(taskIndex < tasks[msg.sender].length, "Invalid task index.");
        require(
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("completed")) ||
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("in progress")) ||
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("started")) ||
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("not started")),
            "Invalid status"
        );
        
        tasks[msg.sender][taskIndex].status = newStatus;
        emit TaskStatusChanged(msg.sender, taskIndex, newStatus);
    }

    // Функция для получения списка задач пользователя
    function getTasks() public view returns (Task[] memory) {
        return tasks[msg.sender];
    }

}