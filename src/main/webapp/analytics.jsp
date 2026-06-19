<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.taskmanager.model.AnalyticsDTO" %>
<%@ page import="com.taskmanager.model.Task" %>
<%@ page import="java.util.*" %>

<%
AnalyticsDTO analytics =
(AnalyticsDTO) request.getAttribute("analytics");

List<Task> taskList =
(List<Task>) request.getAttribute("taskList");

String selectedFilter =
(String) request.getAttribute("selectedFilter");
%>
<%
Map<String,Integer> monthlyData =
(Map<String,Integer>)
request.getAttribute(
        "monthlyData");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Analytics Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

<style>

/* ─── Reset & Base ─────────────────────────────────── */
*, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

:root {
    --bg-base:       #0d1117;
    --bg-card:       #161b22;
    --bg-elevated:   #1c2128;
    --bg-hover:      #21262d;
    --border:        #30363d;
    --border-subtle: #21262d;
    --text-primary:  #e6edf3;
    --text-secondary:#8b949e;
    --text-muted:    #484f58;
    --success:       #3fb950;
    --info:          #4a90d9;
    --danger:        #f85149;
    --warning:       #f0b429;
    --purple:        #a371f7;
    --radius-sm:     8px;
    --radius-md:     12px;
    --radius-lg:     16px;
    --radius-xl:     20px;
    --shadow-card:   0 1px 3px rgba(0,0,0,0.4), 0 8px 24px rgba(0,0,0,0.3);
    --shadow-hover:  0 4px 12px rgba(0,0,0,0.5), 0 16px 40px rgba(0,0,0,0.4);
    --transition:    all 0.22s cubic-bezier(0.4, 0, 0.2, 1);
}

html { scroll-behavior: smooth; }

body {
    background: var(--bg-base);
    color: var(--text-primary);
    font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
    font-size: 14px;
    line-height: 1.6;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* ─── Page Background Grid ─────────────────────────── */
body::before {
    content: '';
    position: fixed;
    inset: 0;
    background-image:
        linear-gradient(rgba(48,54,61,0.25) 1px, transparent 1px),
        linear-gradient(90deg, rgba(48,54,61,0.25) 1px, transparent 1px);
    background-size: 40px 40px;
    pointer-events: none;
    z-index: 0;
}

/* ─── Layout Wrapper ───────────────────────────────── */
.dashboard-wrapper {
    position: relative;
    z-index: 1;
    max-width: 1280px;
    margin: 0 auto;
    padding: 32px 24px 64px;
}

/* ─── Header / Hero ────────────────────────────────── */
.dashboard-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 24px;
    margin-bottom: 40px;
    padding-bottom: 32px;
    border-bottom: 1px solid var(--border-subtle);
    flex-wrap: wrap;
}

.header-brand {
    display: flex;
    align-items: center;
    gap: 16px;
}

.header-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-md);
    background: linear-gradient(135deg, #1f6feb 0%, #a371f7 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
    box-shadow: 0 0 0 1px rgba(163,113,247,0.3), 0 4px 16px rgba(31,111,235,0.25);
}

.header-text h1 {
    font-size: 22px;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.4px;
    line-height: 1.2;
}

.header-text p {
    font-size: 13px;
    color: var(--text-secondary);
    margin-top: 4px;
    font-weight: 400;
}

.header-controls {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-shrink: 0;
}

.header-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    background: rgba(63,185,80,0.1);
    border: 1px solid rgba(63,185,80,0.25);
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
    color: var(--success);
    letter-spacing: 0.2px;
}

.header-badge::before {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--success);
    animation: pulse-dot 2s infinite;
}

@keyframes pulse-dot {
    0%, 100% { opacity: 1; transform: scale(1); }
    50%       { opacity: 0.5; transform: scale(0.8); }
}

/* ─── Month Filter ──────────────────────────────────── */
.month-filter-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
}

.month-filter-wrap label {
    font-size: 12px;
    font-weight: 500;
    color: var(--text-secondary);
    white-space: nowrap;
}

#monthFilter {
    appearance: none;
    -webkit-appearance: none;
    background: var(--bg-card)
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%238b949e' d='M6 8L1 3h10z'/%3E%3C/svg%3E")
        no-repeat right 12px center;
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-family: inherit;
    font-size: 13px;
    font-weight: 500;
    padding: 8px 36px 8px 12px;
    cursor: pointer;
    transition: var(--transition);
    outline: none;
    min-width: 160px;
}

#monthFilter:hover {
    border-color: #58a6ff;
    background-color: var(--bg-elevated);
}

#monthFilter:focus {
    border-color: #58a6ff;
    box-shadow: 0 0 0 3px rgba(88,166,255,0.15);
}

#monthFilter option {
    background: var(--bg-elevated);
    color: var(--text-primary);
}

/* ─── Section Label ────────────────────────────────── */
.section-label {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.8px;
    text-transform: uppercase;
    color: var(--text-muted);
    margin-bottom: 14px;
}

/* ─── KPI Grid ──────────────────────────────────────── */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 32px;
    animation: fadeInUp 0.4s ease both;
}

@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(16px); }
    to   { opacity: 1; transform: translateY(0); }
}

.stat-card {
    position: relative;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 22px 20px;
    transition: var(--transition);
    box-shadow: var(--shadow-card);
    overflow: hidden;
    cursor: default;
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 2px;
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
    background: var(--card-accent, var(--border));
    transition: var(--transition);
}

.stat-card:hover {
    transform: translateY(-3px);
    box-shadow: var(--shadow-hover);
    border-color: var(--card-accent, var(--border));
}

.stat-card:hover::before {
    opacity: 1;
}

/* Card accent colours */
.stat-card.card-total   { --card-accent: #4a90d9; }
.stat-card.card-done    { --card-accent: #3fb950; }
.stat-card.card-pending { --card-accent: #f0b429; }
.stat-card.card-overdue { --card-accent: #f85149; }
.stat-card.card-rate    { --card-accent: #a371f7; }

.stat-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16px;
}

.stat-card h3 {
    font-size: 12px;
    font-weight: 500;
    color: var(--text-secondary);
    letter-spacing: 0.2px;
    margin: 0;
}

.stat-icon {
    width: 32px;
    height: 32px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    background: var(--icon-bg, rgba(255,255,255,0.06));
    border: 1px solid var(--icon-border, rgba(255,255,255,0.06));
}

.stat-card.card-total   .stat-icon { --icon-bg: rgba(74,144,217,0.12);  --icon-border: rgba(74,144,217,0.2); }
.stat-card.card-done    .stat-icon { --icon-bg: rgba(63,185,80,0.12);   --icon-border: rgba(63,185,80,0.2); }
.stat-card.card-pending .stat-icon { --icon-bg: rgba(240,180,41,0.12);  --icon-border: rgba(240,180,41,0.2); }
.stat-card.card-overdue .stat-icon { --icon-bg: rgba(248,81,73,0.12);   --icon-border: rgba(248,81,73,0.2); }
.stat-card.card-rate    .stat-icon { --icon-bg: rgba(163,113,247,0.12); --icon-border: rgba(163,113,247,0.2); }

.stat-card p {
    font-size: 32px;
    font-weight: 800;
    letter-spacing: -1.5px;
    line-height: 1;
    color: var(--text-primary);
    margin: 0;
}

.stat-card.card-done    p { color: var(--success); }
.stat-card.card-overdue p { color: var(--danger); }
.stat-card.card-rate    p { color: var(--purple); }

.stat-sublabel {
    font-size: 11px;
    color: var(--text-muted);
    margin-top: 8px;
    font-weight: 400;
}

/* ─── Charts Grid ───────────────────────────────────── */
.charts-grid {
    display: grid;
    grid-template-columns: 380px 1fr;
    gap: 16px;
    margin-bottom: 32px;
    animation: fadeInUp 0.5s 0.1s ease both;
}

.chart-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 24px;
    box-shadow: var(--shadow-card);
    transition: var(--transition);
    display: flex;
    flex-direction: column;
}

.chart-card:hover {
    border-color: #30363d;
    box-shadow: var(--shadow-hover);
}

.chart-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
}

.chart-card-header h2 {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    letter-spacing: -0.2px;
}

.chart-tag {
    font-size: 11px;
    font-weight: 500;
    color: var(--text-muted);
    background: var(--bg-hover);
    border: 1px solid var(--border-subtle);
    border-radius: 20px;
    padding: 3px 10px;
}

.chart-canvas-wrap {
    flex: 1;
    position: relative;
    min-height: 260px;
}

canvas {
    max-width: 100%;
}

/* ─── Task Table ────────────────────────────────────── */
.task-list-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-card);
    transition: var(--transition);
    animation: fadeInUp 0.5s 0.2s ease both;
}

.task-list-card:hover {
    box-shadow: var(--shadow-hover);
}

.task-table-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 18px 24px;
    border-bottom: 1px solid var(--border);
    background: var(--bg-elevated);
    flex-wrap: wrap;
    gap: 10px;
}

.task-table-header h2 {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    letter-spacing: -0.2px;
}

.task-filter-label {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 500;
    color: var(--text-secondary);
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 20px;
    padding: 4px 12px;
}

.task-filter-label span {
    color: var(--info);
    font-weight: 600;
}

.table-scroll {
    overflow-x: auto;
    max-height: 420px;
    overflow-y: auto;
}

/* Scrollbar */
.table-scroll::-webkit-scrollbar { width: 6px; height: 6px; }
.table-scroll::-webkit-scrollbar-track { background: transparent; }
.table-scroll::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
.table-scroll::-webkit-scrollbar-thumb:hover { background: #484f58; }

table {
    width: 100%;
    border-collapse: collapse;
}

thead {
    position: sticky;
    top: 0;
    z-index: 10;
}

thead tr {
    background: var(--bg-elevated);
}

th {
    padding: 11px 20px;
    text-align: left;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    color: var(--text-muted);
    border-bottom: 1px solid var(--border);
    white-space: nowrap;
}

tbody tr {
    border-bottom: 1px solid var(--border-subtle);
    transition: background 0.15s ease;
}

tbody tr:nth-child(even) {
    background: rgba(28,33,40,0.4);
}

tbody tr:hover {
    background: var(--bg-hover);
}

tbody tr:last-child {
    border-bottom: none;
}

td {
    padding: 13px 20px;
    font-size: 13px;
    color: var(--text-primary);
    vertical-align: middle;
}

/* Status badges */
.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 3px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.2px;
    white-space: nowrap;
}

.status-badge::before {
    content: '';
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: currentColor;
    opacity: 0.8;
}

/* These classes are applied by JS but we style via attribute patterns too */
td:nth-child(2) {
    /* Status column */
}

/* ─── Empty state ───────────────────────────────────── */
.no-data {
    text-align: center;
    padding: 48px 24px;
    color: var(--text-muted);
    font-size: 13px;
}

.no-data-icon {
    font-size: 32px;
    margin-bottom: 12px;
    opacity: 0.5;
}

/* ─── Divider ───────────────────────────────────────── */
.section-divider {
    height: 1px;
    background: var(--border-subtle);
    margin: 32px 0;
}

/* ─── Responsive ─────────────────────────────────────── */
@media (max-width: 900px) {
    .charts-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 640px) {
    .dashboard-wrapper {
        padding: 20px 16px 48px;
    }

    .dashboard-header {
        flex-direction: column;
        gap: 16px;
        margin-bottom: 28px;
    }

    .header-controls {
        width: 100%;
        justify-content: space-between;
    }

    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .stat-card.card-rate {
        grid-column: 1 / -1;
    }

    .stat-card p {
        font-size: 26px;
    }

    .task-table-header {
        padding: 14px 16px;
    }

    th, td {
        padding: 10px 14px;
    }
}

@media (max-width: 380px) {
    .stats-grid {
        grid-template-columns: 1fr;
    }

    .stat-card.card-rate {
        grid-column: auto;
    }
}

/* ─── Shimmer loading hint ──────────────────────────── */

@keyframes shimmer {
    0%   { background-position: -400px 0; }
    100% { background-position: 400px 0; }
}

/* ─── Focus accessibility ───────────────────────────── */
:focus-visible {
    outline: 2px solid #58a6ff;
    outline-offset: 2px;
}

</style>
</head>

<body>

<div class="dashboard-wrapper">

    <!-- ── Header ─────────────────────────────────────── -->
    <header class="dashboard-header">

        <div class="header-brand">
            <div class="header-icon">📊</div>
            <div class="header-text">
                <h1>Productivity Analytics Dashboard</h1>
                <p>Track productivity, task completion trends, and performance insights.</p>
            </div>
        </div>

        <div class="header-controls">
            <div class="header-badge">Live</div>

            <div class="month-filter-wrap">
                <label for="monthFilter">Month</label>
                <select id="monthFilter">

                    <option value="<%= java.time.LocalDate.now()
                            .toString()
                            .substring(0,7) %>">
                        Current Month
                    </option>

                    <%
                    if(monthlyData != null){
                        for(String month : monthlyData.keySet()){
                    %>
                        <option value="<%= month %>"><%= month %></option>
                    <%
                        }
                    }
                    %>

                </select>
            </div>
        </div>

    </header>

    <!-- ── KPI Cards ──────────────────────────────────── -->
    <div class="section-label">Key Metrics</div>

    <div class="stats-grid">

        <div class="stat-card card-total">
            <div class="stat-card-header">
                <h3>Total Tasks</h3>
                <div class="stat-icon">📋</div>
            </div>
            <p id="totalTasks"><%= analytics.getTotalTasks() %></p>
            <div class="stat-sublabel">All tasks across periods</div>
        </div>

        <div class="stat-card card-done">
            <div class="stat-card-header">
                <h3>Completed</h3>
                <div class="stat-icon">✅</div>
            </div>
            <p id="completedTasksCard"><%= analytics.getCompletedTasks() %></p>
            <div class="stat-sublabel">Successfully finished</div>
        </div>

        <div class="stat-card card-pending">
            <div class="stat-card-header">
                <h3>Pending</h3>
                <div class="stat-icon">⏳</div>
            </div>
            <p id="pendingTasksCard"><%= analytics.getPendingTasks() %></p>
            <div class="stat-sublabel">Awaiting completion</div>
        </div>

        <div class="stat-card card-overdue">
            <div class="stat-card-header">
                <h3>Overdue</h3>
                <div class="stat-icon">⚠️</div>
            </div>
            <p id="overdueTasksCard"><%= analytics.getOverdueTasks() %></p>
            <div class="stat-sublabel">Passed due date</div>
        </div>

        <div class="stat-card card-rate">
            <div class="stat-card-header">
                <h3>Completion Rate</h3>
                <div class="stat-icon">🎯</div>
            </div>
            <p id="completionRateCard"><%= String.format("%.1f", analytics.getCompletionRate()) %>%</p>
            <div class="stat-sublabel">Overall performance score</div>
        </div>

    </div>

    <!-- ── Charts ──────────────────────────────────────── -->
    <div class="section-label">Analytics Overview</div>

    <div class="charts-grid">

        <div class="chart-card">
            <div class="chart-card-header">
                <h2>Task Distribution</h2>
                <span class="chart-tag">Pie View</span>
            </div>
            <div class="chart-canvas-wrap">
                <canvas id="taskPieChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-card-header">
                <h2>Monthly Productivity Trend</h2>
                <span class="chart-tag">Line View</span>
            </div>
            <div class="chart-canvas-wrap">
                <canvas id="lineChart"></canvas>
            </div>
        </div>

    </div>

    <!-- ── Task Table ───────────────────────────────────── -->
    <div class="section-label">Task Details</div>

    <div class="task-list-card">

        <div class="task-table-header">
            <h2>Task Details</h2>
            <div class="task-filter-label">
                Filter:
                <span>
                    <%= selectedFilter != null
                        ? selectedFilter + " Tasks"
                        : "Click a Pie Chart segment" %>
                </span>
            </div>
        </div>

        <div class="table-scroll">
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Due Date</th>
                    </tr>
                </thead>
                <tbody id="taskTableBody">

                <%
                if(taskList != null && !taskList.isEmpty()){
                    for(Task task : taskList){
                        String status = task.getStatus();
                        String badgeStyle = "";
                        if("Completed".equalsIgnoreCase(status)){
                            badgeStyle = "background:rgba(63,185,80,0.12);color:#3fb950;border:1px solid rgba(63,185,80,0.25);";
                        } else if("Pending".equalsIgnoreCase(status)){
                            badgeStyle = "background:rgba(240,180,41,0.12);color:#f0b429;border:1px solid rgba(240,180,41,0.25);";
                        } else if("Overdue".equalsIgnoreCase(status)){
                            badgeStyle = "background:rgba(248,81,73,0.12);color:#f85149;border:1px solid rgba(248,81,73,0.25);";
                        } else {
                            badgeStyle = "background:rgba(74,144,217,0.12);color:#4a90d9;border:1px solid rgba(74,144,217,0.25);";
                        }
                %>
                    <tr>
                        <td><%= task.getTitle() %></td>
                        <td>
                            <span class="status-badge" style="<%= badgeStyle %>">
                                <%= status %>
                            </span>
                        </td>
                        <td style="color:#8b949e;font-variant-numeric:tabular-nums;">
                            <%= task.getDueDate() %>
                        </td>
                    </tr>
                <%
                    }
                } else {
                %>
                    <tr>
                        <td colspan="3">
                            <div class="no-data">
                                <div class="no-data-icon">📭</div>
                                No tasks to display. Select a pie chart segment to filter.
                            </div>
                        </td>
                    </tr>
                <%
                }
                %>

                </tbody>
            </table>
        </div>

    </div>

</div><!-- /dashboard-wrapper -->


<!-- ── JSP Data Injection ───────────────────────────── -->
<%
StringBuilder months = new StringBuilder();
StringBuilder counts = new StringBuilder();

if(monthlyData != null){
    for(Map.Entry<String,Integer> entry : monthlyData.entrySet()){
        months.append("'").append(entry.getKey()).append("',");
        counts.append(entry.getValue()).append(",");
    }
}
%>

<script>

const contextPath  = "<%= request.getContextPath() %>";

const completedTasks = <%= analytics.getCompletedTasks() %>;
const pendingTasks   = <%= analytics.getPendingTasks() %>;
const overdueTasks   = <%= analytics.getOverdueTasks() %>;

const monthlyLabels = [ <%= months.toString() %> ];
const monthlyCounts = [ <%= counts.toString() %> ];

</script>

<script src="js/chart.js"></script>
<!-- Charts loaded from js/chart.js -->

</body>
</html>
