/**
 * Main application file with various code quality issues
 */

// TODO: Refactor this file into smaller modules
// FIXME: Handle error cases properly

/**
 * Calculate the average of an array of numbers
 * This is a duplicate function that exists in Python files as well
 */
function calculateAverage(numbers) {
    if (!numbers || numbers.length === 0) {
        return 0;
    }
    
    const sum = numbers.reduce((acc, val) => acc + val, 0);
    return sum / numbers.length;
}

/**
 * Find the maximum value in an array
 * This is also a duplicate function
 */
function findMax(numbers) {
    if (!numbers || numbers.length === 0) {
        return null;
    }
    
    let maxValue = numbers[0];
    for (let i = 1; i < numbers.length; i++) {
        if (numbers[i] > maxValue) {
            maxValue = numbers[i];
        }
    }
    
    return maxValue;
}

/**
 * A very long function that does too many things
 */
function processUserData(userData) {
    // TODO: Split this function into smaller, more focused functions
    
    if (!userData) {
        console.error('No user data provided');
        return null;
    }
    
    // Validate user data
    const errors = [];
    if (!userData.name) {
        errors.push('Name is required');
    }
    
    if (!userData.email) {
        errors.push('Email is required');
    } else if (!userData.email.includes('@')) {
        errors.push('Invalid email format');
    }
    
    if (!userData.age) {
        errors.push('Age is required');
    } else if (isNaN(userData.age) || userData.age < 0) {
        errors.push('Age must be a positive number');
    }
    
    if (errors.length > 0) {
        console.error('Validation errors:', errors);
        return { success: false, errors };
    }
    
    // Process user data
    const processedData = {
        id: generateUserId(userData),
        displayName: formatUserName(userData),
        contactInfo: {
            email: userData.email.toLowerCase(),
            phone: formatPhoneNumber(userData.phone)
        },
        age: parseInt(userData.age),
        ageGroup: calculateAgeGroup(userData.age),
        registrationDate: new Date(),
        lastUpdated: new Date()
    };
    
    // Calculate user statistics
    if (userData.activities) {
        const activityStats = {
            total: userData.activities.length,
            categories: {}
        };
        
        for (const activity of userData.activities) {
            if (!activityStats.categories[activity.type]) {
                activityStats.categories[activity.type] = 0;
            }
            activityStats.categories[activity.type]++;
        }
        
        processedData.activityStats = activityStats;
    }
    
    // Generate recommendations
    if (userData.interests && userData.interests.length > 0) {
        processedData.recommendations = generateRecommendations(userData.interests);
    }
    
    // FIXME: This function is doing too many things and is too long
    
    return { success: true, data: processedData };
}

// Helper functions
function generateUserId(userData) {
    return `user_${userData.name.substring(0, 3).toLowerCase()}_${Date.now()}`;
}

function formatUserName(userData) {
    return `${userData.name} ${userData.lastName || ''}`.trim();
}

function formatPhoneNumber(phone) {
    if (!phone) return '';
    // Just a simple format, not a real phone formatter
    return phone.replace(/[^0-9]/g, '');
}

function calculateAgeGroup(age) {
    age = parseInt(age);
    if (age < 18) return 'under18';
    if (age < 30) return '18-29';
    if (age < 50) return '30-49';
    if (age < 65) return '50-64';
    return '65plus';
}

function generateRecommendations(interests) {
    // This is a placeholder for a recommendation algorithm
    // TODO: Implement a real recommendation system
    return [
        'recommendation1',
        'recommendation2',
        'recommendation3'
    ];
}

// Export functions for use in other modules
module.exports = {
    calculateAverage,
    findMax,
    processUserData
};