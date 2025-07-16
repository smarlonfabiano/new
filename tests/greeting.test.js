/**
 * Tests for the greeting utility functions
 */

const { greet } = require('../src/utils/greeting');

describe('Greeting Utility', () => {
  test('greet function returns correct greeting', () => {
    expect(greet('World')).toBe('Hello, World!');
    expect(greet('User')).toBe('Hello, User!');
  });
});