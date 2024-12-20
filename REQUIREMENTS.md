
# Requirements

## Onboarding

**Objective**: Create a seamless onboarding flow that guides new users through account creation with minimal friction, capturing essential information and setting up the account in two simple screens.

### User Flow
1. Landing screen: Welcome to `<AppName>`, what’s your name?
2. Account creation screen: Please enter your email and password to create an account.

### Screen 1: Landing/Intro
1. **UI**
   - Greeting text: "Welcome to `<AppName>`, what’s your name?"
   - Name input field
     - Placeholder: "Your name here"
     - Character Limit: 30 characters
   - Next button
     - Label: "Next"
     - Disabled until at least 1 character entered in name input
   - Progress indicator
     - Show progress (e.g., "Step 1 of 2") to inform the user about the onboarding process.

2. **Functionality**
   - **Input Validation**:
     - Enforce character limit (30 characters) for name input.
     - Allow only alphabetic characters and spaces.
     - Provide real-time feedback for invalid characters (e.g., "Name can only include letters").
   - **Next Button**:
     - Remains inactive until at least one character is entered.
     - On press, proceed to the Account Creation Screen.
   - **Error Handling**:
     - If input exceeds character limit, prevent additional characters.
     - Show an error if special characters are entered, prompting users to enter a valid name.

### Screen 2: Account Creation
1. **UI Components**
   - Instruction text: "Finish making your account"
   - Account profile picture input
   - Email Input Field
     - Placeholder text: "Enter your email"
     - Validate email format in real-time.
   - Password Input Field
     - Placeholder text: "Enter your password"
     - Mask input by default, with a toggle to show/hide password.
   - Confirm Password Input Field
     - Placeholder text: "Confirm your password"
     - Mask input by default, with a toggle to show/hide password.
   - Create Account Button
     - Label: "Create Account"
     - Inactive until valid email and password inputs are detected.
   - Back Button
     - Allows users to return to the previous screen.

2. **Functionality**
   - **Input Validation**:
     - Email: Real-time validation to check format (e.g., "example@example.com").
     - Password: Enforce requirements:
       - Minimum 8 characters
       - At least one uppercase letter
       - At least one number
     - Show error messages for invalid email format or password that doesn’t meet criteria.
     - Confirmed password field matches valid password field.
   - **Create Account Button**:
     - Becomes active once all fields are valid.
     - On press, attempt to create an account and move to the main app screen if successful.

3. **Error Handling**
   - Email: If invalid format is detected, display message "Please enter a valid email address."
   - Password: If requirements aren’t met, provide feedback (e.g., "Password must be at least 8 characters with an uppercase letter and a number").
   - Network Errors: If there’s an error creating the account (e.g., network error), show a dismissable alert with a retry option.

---

## Nav Bar

**Objective**: Enable easy navigation through the app to critical pages.

### User Flow
1. Nav bar is accessible from any page in the app except the two onboarding pages.
2. Clicking an item on the nav bar will take the user to the item’s corresponding page.

### Nav Bar UI Components
   - Home icon: Directs user to home page when clicked
   - Map icon: Directs user to map page when clicked
   - New post icon: Directs user to post page when clicked
   - People icon: Directs user to people page when clicked

### Functionality
   - Icon of the current page is filled in while the rest are outlines.

---

## Home Page

**Objective**: Provide users with a centralized page showing recent reviews of local bars from friends and the general public.

### User Flow
1. User chooses from review recency view (default) and bar-by-bar view at top of page.
2. User scrolls through reviews.

---

## Component 1: Review Component

**UI Elements**
   - Image (optional): Top item in review component, scales to span whole component’s horizontal.
   - Bar Name: Bold.
   - Star Rating: Out of five stars; selected stars filled, unselected stars outlined.
   - Description
   - Poster Profile Pic
   - Poster Profile Name

**Error Handling**
   - If any field is missing, do not include it in the review component.

---

## Map

**Objective**: Integrate MapKit to give users an interactive way to check the status of bars in their area.

---

## New Post

**Objective**: Allow users to create reviews of bars.

---

## Profile / People Page

**Objective**: Provide a basic profile page with the option to add friends if implemented.

**User Flow**
   - Opens People page.
   - Sees profile.

### UI Elements
   - Profile picture
   - Profile name
   - Edit Profile button
