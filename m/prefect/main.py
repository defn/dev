from prefect import flow, task
import httpx

@task(log_prints=True)
def get_stars(repo: str):
    url = f"https://api.github.com/repos/{repo}"
    count = httpx.get(url).json()["stargazers_count"]
    print(f"{repo} has {count} stars!")


@flow(name="stars")
def github_stars(repos: list[str]):
    for repo in repos:
        get_stars(repo)

if __name__=="__main__":
    github_stars(["defn/dev"])