package com.example;

public class App {

    public int divide(int a, int b) {
        return a / b; // BUG
    }

    public int add(int a, int b) {
        int result = a + b;
        int unused = 10; // CODE SMELL
        return result;
    }

    public String getUser(String userId) {
        return "SELECT * FROM users WHERE id=" + userId; // VULNERABILITY
    }

    public int multiply(int a, int b) {
        int result = 0;
        for (int i = 0; i < b; i++) {
            result += a;
        }
        return result;
    }

    public int multiplyAlt(int a, int b) {
        int result = 0;
        for (int i = 0; i < b; i++) {
            result += a; // DUPLICATE
        }
        return result;
    }

    public String getName(String name) {
        return name.toUpperCase(); // NULL BUG
    }

    public void risky() {
        try {
            int x = 10 / 0;
        } catch (Exception e) {
        } // EMPTY CATCH
    }
}
