# My Office

## Introduction

Hi Team, Welcome to the My Office repository which is designed specifically designed for the In-house usage for employees with Clean architecture.
With this repository all the employees can maintain daily works,order a refreshment drink and much more.

## About Clean Architecture

Clean Architecture is a way of organizing code in a software project that helps keep it flexible, easy to maintain, and independent of external elements like databases or frameworks. It divides the code into separate layers, each with its own responsibility. This separation makes it easier to manage the code and reduces the impact of changes.

## Features

* **Work entry** - Employee can write down their day-to-day work entries here.
* **Order refreshment** - With this feature one can easily order a refreshment drink and get refreshed.
* **Search leads** - This feature is for the PR team to get all customer details and also make a note of it.
* **Suggestions** - Foremost advantage for an employee to suggest ideas and also to make them and organization grow eventually.
* **Invoice generator** - Generate Quotations and Invoices within our app for Customers.
* **Attendance** - Another advantage for an employee to mark their Presence or Entry whether inside the premises or not. 

## Getting Started

### Prerequisites

Let's make this simple and get this tools available with you before you begin.

+ Android studio / VS Code. 
+ Flutter version 3.10.0 or above. 
+ Dart version 3.1.0 or above. 
+ Java JDK version 11.0.18.

### Installation

- Clone the repository:

```
 git clone https://github.com/onwords-smart-solutions/my_office.git 
 cd My-Office 
 ```

- Navigate to project directory and with Pubspec.yaml file install the dependencies.

### Code Structure

As, I have mentioned above this project is structured with Clean architecture principles. Below I have listed down the structure of the app.

* lib/core : This module contains the app's core functionalities such as Constant values, Common widgets, Custom buttons and styles, etc.,
* lib/features : This module contains the whole app functions.
    * /features/attendance : Module for employee attendance view with date switching options.
    * /features/auth : Module for User authentication sections such as Login and Forgot password.
    * /features/create_lead : Module for creating leads for a single customer.
    * /features/create_product : Module for creating products and attach with database.
    * /features/employee_of_the_week : Module for appreciating employee and reason behind their success.
    * /features/finance : Module to view Office incomes and expenses.
    * /features/food_count : Module to note employee food details on monthly basis.
    * /features/home : Module for user landing screen and staff access.
    * /features/installation_pdf : Module for Installation team to note customer requirements.
    * /features/invoice_generator : Module for generating Invoices and Quotations for customers.
    * /features/leave_approval : Module for approving or declining employee leave for Management and TL's.
    * /features/notifications : Module for daily refreshment and suggestion arrival notifications.
    * /features/pr_dashboard : Module for updating monthly targets and updating daily achieved target.
    * /features/pr_reminder : Module for viewing daily reminders to contact customers for PR team.
    * /features/proxy_attendance : Module for registering proxy entry by TL's and managers for their teams.
    * /features/quotation_template : Module for automated template for Quotations for PR team to customers.
    * /features/refreshment : Module for ordering refreshment drinks and also to order foods on daily basis.
    * /features/sales_points : Module to know respective points for the product and quantity.
    * /features/scan_qr : Module to scan the Qr code and know their points for PR.
    * /features/search_leads : Module for getting all customer details assigned to specific PR.
    * /features/staff_details : Module about entire staffs in the organization.
    * /features/suggestions : Module to lend a suggestion or idea to the management.
    * /features/user : Module with user details.
    * /features/view_suggestions: Module for viewing suggestions made by employees only for CEO.
    * /features/work_details : Module to verify the daily works of employees.
    * /features/work_entry : Module to register daily work done by the employee.
  
### Development guidelines

* Follow a solid principle with clean architecture.
* Use meaningful names for the variables, functions and classes.
* Don't try to change the core functionalities, it may lead to project break.
* Utilize git with clear commit messages as mentioned.

### Version history and Releases

* Android - 2.0.17+87.
* iOS - 2.0.12+87. 



