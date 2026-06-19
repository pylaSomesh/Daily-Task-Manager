<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.taskmanager.model.User" %>
<%@ page import="com.taskmanager.model.Task" %>
<%@ page import="com.taskmanager.util.ToastUtil" %>
<%@ page import="com.taskmanager.util.ProfileImageUtil" %>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
String username = user.getUsername();
String profileImagePath = ProfileImageUtil.getImagePath(user);
String profileInitial = ProfileImageUtil.getInitial(user);
%>

<%
Integer totalTasks     = (Integer) request.getAttribute("totalTasks");
Integer pendingTasks   = (Integer) request.getAttribute("pendingTasks");
Integer completedTasks = (Integer) request.getAttribute("completedTasks");
Double completionPercentage = (Double) request.getAttribute("completionPercentage");
String search        = (String) request.getAttribute("search");
String statusFilter  = (String) request.getAttribute("statusFilter");
String categoryFilter = (String) request.getAttribute("categoryFilter");

if (totalTasks == null) totalTasks = 0;
if (pendingTasks == null) pendingTasks = 0;
if (completedTasks == null) completedTasks = 0;
if (completionPercentage == null) completionPercentage = 0.0;
if (search == null) search = "";
if (statusFilter == null || statusFilter.isEmpty()) statusFilter = "All";
if (categoryFilter == null || categoryFilter.isEmpty()) categoryFilter = "All";

List<Task> taskList = (List<Task>) request.getAttribute("taskList");

String toastType = (String) request.getAttribute("toastType");
String toastMessage = (String) request.getAttribute("toastMessage");
if (toastType == null) {
    toastType = (String) session.getAttribute(ToastUtil.TOAST_TYPE);
    toastMessage = (String) session.getAttribute(ToastUtil.TOAST_MESSAGE);
    if (toastType != null) {
        session.removeAttribute(ToastUtil.TOAST_TYPE);
        session.removeAttribute(ToastUtil.TOAST_MESSAGE);
    }
}

boolean isFiltering = !search.trim().isEmpty()
        || !"All".equalsIgnoreCase(statusFilter)
        || !"All".equalsIgnoreCase(categoryFilter);

StringBuilder filterQuery = new StringBuilder();
if (!search.trim().isEmpty()) {
    if (filterQuery.length() > 0) filterQuery.append("&");
    filterQuery.append("search=").append(URLEncoder.encode(search.trim(), "UTF-8"));
}
if (!"All".equalsIgnoreCase(statusFilter)) {
    if (filterQuery.length() > 0) filterQuery.append("&");
    filterQuery.append("statusFilter=").append(URLEncoder.encode(statusFilter, "UTF-8"));
}
if (!"All".equalsIgnoreCase(categoryFilter)) {
    if (filterQuery.length() > 0) filterQuery.append("&");
    filterQuery.append("categoryFilter=").append(URLEncoder.encode(categoryFilter, "UTF-8"));
}
String filterQueryStr = filterQuery.toString();
String editQuerySuffix = filterQueryStr.isEmpty() ? "" : "&" + filterQueryStr;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager – Dashboard</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/dashboard.css">
    
</head>
<body<% if (toastType != null && toastMessage != null) { %>
    data-toast-type="<%= toastType %>"
    data-toast-message="<%= toastMessage.replace("\"", "&quot;") %>"<% } %>>

<div class="layout">
    <nav class="navbar" role="banner">
        <a href="DashboardServlet" class="navbar-brand" aria-label="Daily Task Manager">
            <span class="navbar-icon">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M9 11l3 3L22 4"/>
                    <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>
                </svg>
            </span>
            <span class="navbar-title">Daily Task Manager</span>
        </a>
  
        <div class="navbar-right">
            <span class="navbar-greeting">Welcome, <strong><%= username %></strong></span>
            <% if (profileImagePath != null) { %>
            <img src="<%= profileImagePath %>" alt="Profile" class="avatar">
            <% } else { %>
            <div class="navbar-avatar" aria-hidden="true"><%= profileInitial %></div>
            <% } %>
            <button type="button" id="theme-toggle" class="theme-toggle" aria-pressed="true">Light</button>
            <a href="profile" class="btn-profile-link">Profile</a>
            <a href="logout" class="btn-logout" aria-label="Log out">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                    <polyline points="16 17 21 12 16 7"/>
                    <line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
                Logout
            </a>
        </div>
    </nav>

    <div class="content">
<div class="page-header">

    <div class="page-header-user">

        <% if (profileImagePath != null) { %>
        <img src="<%= profileImagePath %>"
             alt="Profile picture"
             class="avatar-lg">
        <% } else { %>
        <div class="avatar-fallback avatar-fallback-lg"
             aria-hidden="true">
            <%= profileInitial %>
        </div>
        <% } %>

        <div class="page-header-user-info">
            <h2>My Dashboard</h2>
            <p>Here's an overview of your tasks.</p>
        </div>

    </div>

    <div class="header-actions">

        <a href="analytics"
           class="analytics-btn">

            View Analytics

        </a>

        <span class="page-date"
              id="live-date"
              aria-live="polite">
        </span>

    </div>

</div>

        <div class="stats-grid" role="region" aria-label="Task statistics">
            <div class="stat-card" data-color="blue">
                <div class="stat-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                </div>
                <div class="stat-body">
                    <div class="stat-label">Total Tasks</div>
                    <div class="stat-value"><%= totalTasks %></div>
                    <div class="stat-sub">All tasks created</div>
                </div>
            </div>
            <div class="stat-card" data-color="amber">
                <div class="stat-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </div>
                <div class="stat-body">
                    <div class="stat-label">Pending</div>
                    <div class="stat-value"><%= pendingTasks %></div>
                    <div class="stat-sub">Awaiting completion</div>
                </div>
            </div>
            <div class="stat-card" data-color="green">
                <div class="stat-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                </div>
                <div class="stat-body">
                    <div class="stat-label">Completed</div>
                    <div class="stat-value"><%= completedTasks %></div>
                    <div class="stat-sub">Tasks finished</div>
                </div>
            </div>
            <div class="stat-card" data-color="teal">
                <div class="stat-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                </div>
                <div class="stat-body">
                    <div class="stat-label">Completion</div>
                    <div class="stat-value"><%= String.format("%.1f", completionPercentage) %>%</div>
                    <div class="stat-sub">Overall progress</div>
                </div>
            </div>
        </div>

        <div class="main-grid">
            <aside>
                <div class="card">
                    <div class="card-head" onclick="toggleTaskForm()" style="cursor:pointer;">
                        <div class="card-head-left">
                            <div class="card-head-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            </div>
                            <div><h3>Add New Task</h3><p>Create a task quickly</p></div>
                        </div>
                    </div>
                    <div id="taskFormContainer" class="card-body" style="display:none;">
                        <form class="add-form" action="addTask" method="POST" onsubmit="return validateAddForm(this)">
                            <div class="field">
                                <label for="title">Task Title <span class="required">*</span></label>
                                <div class="input-wrap">
                                    <input type="text" id="title" name="title" placeholder="e.g. Review meeting notes"
                                           required maxlength="200" autocomplete="off">
                                    <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/>
                                    </svg>
                                </div>
                            </div>
                            <div class="field">
                                <label for="dueDate">Due Date <span class="required">*</span></label>
                                <input type="date" id="dueDate" name="dueDate" class="form-control"  required>
                            </div>
                            <div class="field">
                                <label for="priority">Priority <span class="required">*</span></label>
                                <select id="priority" name="priority" class="form-control" required>
                                    <option value="High">High</option>
                                    <option value="Medium" selected>Medium</option>
                                    <option value="Low">Low</option>
                                </select>
                            </div>
                            <div class="field">
                                <label for="category">Category <span class="required">*</span></label>
                                <select id="category" name="category" class="form-control" required>
                                    <option value="Work">Work</option>
                                    <option value="Personal" selected>Personal</option>
                                    <option value="Study">Study</option>
                                    <option value="Health">Health</option>
                                </select>
                            </div>
                            <button type="submit" class="btn-add">Add Task</button>
                        </form>
                    </div>
                </div>
            </aside>

            <section aria-labelledby="tasklist-heading">
                <div class="card">
                    <div class="card-head">
                        <div class="card-head-left">
                            <div class="card-head-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/></svg>
                            </div>
                            <div><h3 id="tasklist-heading">Task List</h3><p>All your tasks in one place</p></div>
                        </div>
                        <% if (taskList != null && !taskList.isEmpty()) { %>
                        <span class="task-count-badge"><%= taskList.size() %> task<%= taskList.size() != 1 ? "s" : "" %></span>
                        <% } %>
                    </div>

                    <div class="task-toolbar">
                        <form method="GET" action="DashboardServlet" class="task-toolbar-form">
                            <div class="toolbar-field">
                                <label for="search" class="sr-only">Search tasks</label>
                                <input type="text" id="search" name="search" class="form-control toolbar-search"
                                       placeholder="Search by title..." value="<%= search.replace("\"", "&quot;") %>"
                                       maxlength="200" autocomplete="off">
                            </div>
                            <div class="toolbar-field">
                                <label for="statusFilter" class="sr-only">Filter by status</label>
                                <select id="statusFilter" name="statusFilter" class="form-control">
                                    <option value="All" <%= "All".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>All Status</option>
                                    <option value="Pending" <%= "Pending".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Pending</option>
                                    <option value="Completed" <%= "Completed".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Completed</option>
                                </select>
                            </div>
                            <div class="toolbar-field">
                                <label for="categoryFilter" class="sr-only">Filter by category</label>
                                <select id="categoryFilter" name="categoryFilter" class="form-control">
                                    <option value="All" <%= "All".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>All Categories</option>
                                    <option value="Work" <%= "Work".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Work</option>
                                    <option value="Personal" <%= "Personal".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Personal</option>
                                    <option value="Study" <%= "Study".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Study</option>
                                    <option value="Health" <%= "Health".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Health</option>
                                </select>
                            </div>
                            <button type="submit" class="btn-toolbar">Apply</button>
                            <% if (isFiltering) { %>
                            <a href="DashboardServlet" class="btn-toolbar btn-toolbar-clear">Clear</a>
                            <% } %>
                        </form>
                    </div>

                    <% boolean hasTasks = (taskList != null && !taskList.isEmpty()); %>
                    <% if (hasTasks) { %>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Task Title</th>
                                    <th scope="col">Due Date</th>
                                    <th scope="col">Category</th>
                                    <th scope="col">Priority</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% for (Task task : taskList) {
                                boolean isCompleted = "Completed".equalsIgnoreCase(task.getStatus());
                                String priority = task.getPriority();
                                if (priority == null || priority.trim().isEmpty()) priority = "Medium";
                                String priorityClass = "badge-priority-medium";
                                if ("High".equalsIgnoreCase(priority)) priorityClass = "badge-priority-high";
                                else if ("Low".equalsIgnoreCase(priority)) priorityClass = "badge-priority-low";
                                String category = task.getCategory();
                                if (category == null || category.trim().isEmpty()) category = "Personal";
                                String categoryClass = "badge-category badge-category-" + category.toLowerCase();
                                String safeTitle = task.getTitle().replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
                            %>
                                <tr>
                                    <td class="td-id">#<%= task.getId() %></td>
                                    <td class="td-title"><span title="<%= safeTitle %>"><%= safeTitle %></span></td>
                                    <td class="td-due-date"><%= task.getDueDate() == null ? "-" : task.getDueDate() %></td>
                                    <td><span class="<%= categoryClass %>"><%= category %></span></td>
                                    <td><span class="badge <%= priorityClass %>"><span class="badge-dot" aria-hidden="true"></span><%= priority %></span></td>
                                    <td>
                                        <% if (isCompleted) { %>
                                        <span class="badge badge-completed"><span class="badge-dot" aria-hidden="true"></span>Completed</span>
                                        <% } else { %>
                                        <span class="badge badge-pending"><span class="badge-dot" aria-hidden="true"></span>Pending</span>
                                        <% } %>
                                    </td>
                                    <td class="actions-cell">
                                        <a href="editTask?id=<%= task.getId() %><%= editQuerySuffix %>" class="action-btn btn-edit">Edit</a>
                                        <% if (!isCompleted) { %>
                                        <a href="completeTask?id=<%= task.getId() %>" class="action-btn btn-complete">Complete</a>
                                        <% } %>
                                        <a href="deleteTask?id=<%= task.getId() %>" class="action-btn btn-delete"
                                           onclick="return confirmDelete(event, this)">Delete</a>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="empty-state" role="status">
                        <% if (isFiltering) { %>
                        <h4>No matching tasks</h4>
                        <p>Try adjusting your search or filters.</p>
                        <% } else { %>
                        <h4>No tasks available</h4>
                        <p>Create your first task to get started.</p>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </section>
        </div>
    </div>

<footer class="footer">

    <p>
        Daily Task Manager © 2026
    </p>

   <p>
    Support:
    <a href="mailto:dailytaskmanager.project@gmail.com"
       style="color: inherit; text-decoration: none;">
        dailytaskmanager.project@gmail.com
    </a>
</p>

</footer>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script src="js/dashboard.js"></script>

<script>
function toggleTaskForm(){
 const form=document.getElementById('taskFormContainer');
 if(!form) return;
 form.style.display=(form.style.display==='none'||form.style.display==='')?'block':'none';
}
</script>

</body>
</html>
