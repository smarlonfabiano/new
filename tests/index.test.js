/**
 * Tests for the main application
 */

const { main } = require('../src/index');

// Mock console.log to test output
console.log = jest.fn();

describe('Main Application', () => {
  test('main function logs expected messages', () => {
    // Call the main function
    main();
    
    // Check that console.log was called with the expected arguments
    expect(console.log).toHaveBeenCalledWith('Application started');
    expect(console.log).toHaveBeenCalledWith('Hello, World!');
  });
});