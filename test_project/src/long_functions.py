#!/usr/bin/env python3
"""
This file contains intentionally long functions to demonstrate the code quality metrics script.
"""

# A very long function with low comment density
def very_long_function_with_many_lines():
    """This function is intentionally long to demonstrate the code quality metrics."""
    result = 0
    for i in range(1, 100):
        if i % 2 == 0:
            result += i
        else:
            result -= i
        
        if i % 3 == 0:
            result *= 2
        elif i % 5 == 0:
            result /= 2
        elif i % 7 == 0:
            result += 10
        
        # Some more code to make this function longer
        temp = 0
        for j in range(1, i):
            temp += j ** 2
            if j % 2 == 0:
                temp -= j
            else:
                temp += j * 2
        
        result += temp / 1000
    
    # Even more code to make this function longer
    data = []
    for i in range(1, 50):
        item = {"id": i, "value": i * i}
        if i % 2 == 0:
            item["type"] = "even"
        else:
            item["type"] = "odd"
        
        if i % 3 == 0:
            item["divisible_by_three"] = True
        else:
            item["divisible_by_three"] = False
        
        data.append(item)
    
    # Process the data
    processed_data = []
    for item in data:
        new_item = {}
        new_item["original_id"] = item["id"]
        new_item["squared_value"] = item["value"]
        new_item["is_even"] = item["type"] == "even"
        new_item["is_divisible_by_three"] = item["divisible_by_three"]
        
        # Add some calculated fields
        new_item["cubed_value"] = item["id"] ** 3
        new_item["is_prime"] = is_prime(item["id"])
        
        processed_data.append(new_item)
    
    # TODO: Optimize this function, it's too long and does too many things
    
    return result, processed_data

# Helper function
def is_prime(n):
    """Check if a number is prime."""
    if n <= 1:
        return False
    if n <= 3:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True

# Another long function with deeply nested code
def process_nested_data(data):
    """Process nested data structures with deep nesting."""
    result = []
    
    for category in data:
        if "items" in category:
            category_items = []
            
            for item in category["items"]:
                if "properties" in item:
                    processed_properties = {}
                    
                    for prop_key, prop_value in item["properties"].items():
                        if isinstance(prop_value, dict):
                            processed_sub_props = {}
                            
                            for sub_key, sub_value in prop_value.items():
                                if isinstance(sub_value, dict):
                                    processed_sub_sub_props = {}
                                    
                                    for sub_sub_key, sub_sub_value in sub_value.items():
                                        if isinstance(sub_sub_value, list):
                                            processed_list = []
                                            
                                            for list_item in sub_sub_value:
                                                if isinstance(list_item, dict):
                                                    processed_dict = {}
                                                    
                                                    for dict_key, dict_value in list_item.items():
                                                        # FIXME: This is too deeply nested, refactor this
                                                        processed_dict[dict_key] = str(dict_value).upper()
                                                    
                                                    processed_list.append(processed_dict)
                                                else:
                                                    processed_list.append(list_item)
                                            
                                            processed_sub_sub_props[sub_sub_key] = processed_list
                                        else:
                                            processed_sub_sub_props[sub_sub_key] = sub_sub_value
                                    
                                    processed_sub_props[sub_key] = processed_sub_sub_props
                                else:
                                    processed_sub_props[sub_key] = sub_value
                            
                            processed_properties[prop_key] = processed_sub_props
                        else:
                            processed_properties[prop_key] = prop_value
                    
                    item["processed_properties"] = processed_properties
                
                category_items.append(item)
            
            category["processed_items"] = category_items
        
        result.append(category)
    
    return result

# Duplicate function (will be duplicated in another file)
def calculate_average(numbers):
    """Calculate the average of a list of numbers."""
    if not numbers:
        return 0
    return sum(numbers) / len(numbers)

if __name__ == "__main__":
    print("This file contains examples of long functions and deeply nested code.")