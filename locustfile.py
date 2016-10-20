from locust import HttpLocust, TaskSet, task

class MyTask(TaskSet):
    @task
    def task(self):
        self.client.get("/")

class PerformanceTest(HttpLocust):
    task_set = MyTask
