// ==========================
// GLOBAL VARIABLES
// ==========================

let pieChart;
let selectedMonth = "";



// ==========================
// PIE CHART
// ==========================

const pieCtx =
document.getElementById(
    "taskPieChart");

console.log("Pie Canvas:", pieCtx);

if (pieCtx) {

    pieChart =
    new Chart(pieCtx, {

        type: "pie",

        data: {

            labels: [
                "Completed",
                "Pending",
                "Overdue"
            ],

            datasets: [{

                data: [

                    completedTasks,

                    pendingTasks,

                    overdueTasks

                ],

                backgroundColor: [

                    "#3fb950",
                    "#4a90d9",
                    "#f85149"

                ],

                borderWidth: 1
            }]
        },

        options: {

            responsive: true,

            plugins: {

                legend: {

                    position: "bottom"
                }
            },

            onClick: (event, elements) => {

                if (elements.length > 0) {

                    const index =
                        elements[0].index;

                    const status =
                        [
                            "Completed",
                            "Pending",
                            "Overdue"
                        ][index];

                  

						fetch(
						    contextPath +
						    "/filterTasks?status=" +
						    status +
						    "&month=" +
						    selectedMonth
						)
                    .then(response =>
                        response.json())
                    .then(tasks => {

                       

                        let html = "";

                        tasks.forEach(task => {

                            html += `
                            <tr>
                                <td>${task.title}</td>
                                <td>${task.status}</td>
                                <td>${task.dueDate}</td>
                            </tr>`;
                        });

                        const tableBody =
                            document.getElementById(
                                "taskTableBody");

                        if (tableBody) {

                            tableBody.innerHTML =
                                html;
                        }
                    })
                    .catch(error => {

                        console.error(
                            "Fetch Error:",
                            error);
                    });
                }
            }
        }
    });
}

// ==========================
// MONTHLY PRODUCTIVITY LINE
// ==========================

const lineCtx =
document.getElementById(
    "lineChart");



if (lineCtx) {

    new Chart(lineCtx, {

        type: "line",

        data: {

            labels:
                monthlyLabels,

            datasets: [{

                label:
                    "Completed Tasks",

                data:
                    monthlyCounts,

                borderColor:
                    "#3fb950",

                backgroundColor:
                    "#3fb950",

                tension: 0.4,

                fill: false
            }]
        },

        options: {

            responsive: true,

            scales: {

                y: {

                    beginAtZero: true
                }
            }
        }
    });
}

// ==========================
// MONTH DROPDOWN FILTER
// ==========================

const monthFilter =
document.getElementById(
    "monthFilter");

if(monthFilter){

    monthFilter.addEventListener(

        "change",

        function(){
			selectedMonth =
			            this.value;

            fetch(

                contextPath +

                "/monthAnalytics?month=" +

                this.value
            )

            .then(response =>
                response.json())

            .then(data => {

                console.log(
                    "Month Analytics:",
                    data);

                if(pieChart){

                    pieChart.data
                    .datasets[0]
                    .data = [

                        data.completed,

                        data.pending,

                        data.overdue

                    ];

                    pieChart.update();
					document
					.getElementById(
					    "totalTasks")
					.innerText =
					data.total;

					document
					.getElementById(
					    "completedTasksCard")
					.innerText =
					data.completed;

					document
					.getElementById(
					    "pendingTasksCard")
					.innerText =
					data.pending;

					document
					.getElementById(
					    "overdueTasksCard")
					.innerText =
					data.overdue;

					document
					.getElementById(
					    "completionRateCard")
					.innerText =
					data.completionRate
					+ "%";
					
					const tableBody =
					document.getElementById(
					    "taskTableBody");

					if(tableBody){

					    tableBody.innerHTML = "";
					}
					

					  
                }
            })

            .catch(error => {

                console.error(
                    "Month Filter Error:",
                    error);
            });
        });
}