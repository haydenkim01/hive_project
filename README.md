[![Documentation Status](https://readthedocs.org/projects/hive-project/badge/?version=latest)](https://hive-project.readthedocs.io/en/latest/?badge=latest)

## hive_project
### queries/top_movies.q
    (1) ratings table
    (2) users table
    (3) movies table
    (4) top_movies table
      * partitioned table
      * (1), (2), (3)으로부터 데이터를 가져와서, user의 occupation과 moive title로 Group By.
      * occupation과 평점 순으로 정렬.
      * 리뷰 개수가 5개 초과하는 데이터만 사용.
