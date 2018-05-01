# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    gdp > (
      SELECT
        gdp
      FROM
        countries
      WHERE
        continent = 'Europe' AND gdp IS NOT NULL
      ORDER BY gdp DESC
      Limit 1)
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  # Split up countries into continents
  # Find the largest country in that continent
  execute(<<-SQL)
  SELECT
    continent, name, area
  FROM
    countries
  WHERE
      area in (
      SELECT
        MAX(area) AS area
      FROM
        countries
      GROUP BY
        continent
      )
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  # Find largest country in each continent, then check if they have 3x the population of
  # the second largest in their continent
  execute(<<-SQL)
  SELECT
    countries.name, countries.continent
  FROM
    countries, (
      SELECT
        continent, Max(population) AS population 
      FROM
        countries
      WHERE
        population NOT IN (
          SELECT
            Max(population)
          FROM
            countries
          GROUP BY
            continent
        )
      GROUP BY
        continent
      )AS countries_2
  WHERE
    countries.continent = countries_2.continent AND countries.population >= (countries_2.population * 3)

  SQL
end
