import time
from schedule import Schedule

def solve(schedule: Schedule):
    """
    Your solution of the problem
    :param schedule: object describing the input
    :return: a list of tuples of the form (c,t) where c is a course and t a time slot. 
    """
    # 1. Generate an initial state (all courses in time slot 1)
    current_solution = generate_initial_solution(schedule)
    current_score = evaluate_solution(current_solution, schedule)
    
    # 2. Define the stopping criterion (theta) - 5 mins max
    start_time = time.time()
    time_limit = 5 * 60  # 5 minutes in seconds
    
    # 3. Local Search Loop (Hill Climbing)
    while time.time() - start_time < time_limit:
        next_solution = get_best_neighbour(current_solution, schedule)
        next_score = evaluate_solution(next_solution, schedule)
        
        # If the neighbor is strictly better, move to it
        if next_score < current_score:
            current_solution = next_solution
            current_score = next_score
        else:
            # We reached a local optimum or a valid solution
            break
            
    return current_solution

def generate_initial_solution(schedule: Schedule):
    # We put all courses in the same time slot initially.
    solution = dict()

    time_slot_idx = 1
    for c in schedule.course_list:
        solution[c] = time_slot_idx

    return solution

# N(s)
# TODO: Maybe use a generator (yield instead of return) for memory constraints
# Not used for the max/min conflicts heuristic we ended up using
def get_neighbours(solution):
    neighbours = []
    # Determine the highest time slot currently in use.
    # We use max(...) + 2 in the range to allow the possibility of assigning a course to a brand new time slot.
    max_time_slot = max(solution.values()) if solution else 0
    possible_slots = range(1, max_time_slot + 2)
    
    for course, current_slot in solution.items():
        for new_slot in possible_slots:
            if new_slot != current_slot:
                # Create a copy of the current solution so we don't mutate the original dictionary
                new_solution = solution.copy()
                new_solution[course] = new_slot
                neighbours.append(new_solution)
                
    return neighbours

# L(s)
def get_valid_neighbours(solution):
    return

# Q(s)
def get_best_neighbour(solution, schedule: Schedule):
    # 4 selection functions to choose from:
    # 1: Best neighbour
    # 2: First better neighbour
    # 3: max/min conflicts
    # 4: min conflicts
    # Lets try to use max/min conflicts function
    
    # Step 1: Get the course with the most conflicts
    max_conflicts = -1
    worst_course = None
    
    for course in schedule.course_list:
        # Count how many neighbors have the exact same time slot as this course
        conflicts = sum(1 for neighbor in schedule.get_node_conflicts(course) if solution[course] == solution[neighbor])
        if conflicts > max_conflicts:
            max_conflicts = conflicts
            worst_course = course
            
    # If the worst course has 0 conflicts, the current solution is already valid
    if max_conflicts == 0:
        return solution
        
    # Step 2: Move it to the first time slot with the least conflicts (or create new one if none exists)
    max_time_slot = max(solution.values()) if solution else 0
    possible_slots = range(1, max_time_slot + 2)
    
    best_slot = solution[worst_course]
    min_slot_conflicts = float('inf')
    
    for slot in possible_slots:
        slot_conflicts = sum(1 for neighbor in schedule.get_node_conflicts(worst_course) if solution[neighbor] == slot)
        if slot_conflicts < min_slot_conflicts:
            min_slot_conflicts = slot_conflicts
            best_slot = slot
            if min_slot_conflicts == 0:
                break  # We found a perfect slot with 0 conflicts, no need to keep checking
                
    # Create the new neighbor
    best_neighbour = solution.copy()
    best_neighbour[worst_course] = best_slot
    
    return best_neighbour

# f(s)
def evaluate_solution(solution, schedule: Schedule):
    # We want to minimize schedule.get_n_creneaux(solution), but we must heavily penalize conflicts
    num_slots = schedule.get_n_creneaux(solution)
    num_conflicts = sum(1 for c1, c2 in schedule.conflict_list if solution[c1] == solution[c2])
    
    # Weight the conflicts heavily so the algorithm always prioritizes resolving conflicts first
    return num_slots + 1000 * num_conflicts
