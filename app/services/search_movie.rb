require 'themoviedb'
require 'dotenv'

class SearchMovie

  def initialize
    Dotenv.load

    Tmdb::Api.key(ENV['API_KEY']) #Récupère la clé API dans le .env
    Tmdb::Api.language("fr") #Configure les résultats pour les afficher en français

    @configuration = Tmdb::Configuration.new
    @months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
    #On s'en sert plus bas, pour afficher les mois et rendre ça un peu plus joli
  end

  def search(name)
    results = [] #L'array des résultats qu'on va retourner à la fin
    Tmdb::Movie.find(name).each do |movie| #On lance une recherche
      current_movie = {}
      current_movie[:title] = movie.title #On enregistre le titre
      temp_date = movie.release_date.split('-') #Coupe la date qui est de base au format ANNEE-MOIS-JOUR puis met les 3 éléments dans un array
      unless movie.release_date == "" #Si une date de sortie a été trouvée
        current_movie[:date] = "#{temp_date[2]} #{@months[temp_date[1].to_i - 1]} #{temp_date[0]}" #Pour transformer par exemple un "2018-11-08" en un joli "8 Novembre 2018"
      end
      current_movie[:directors] = [] #On prépare le hash, s'il y a plusieurs réalisateurs
      current_movie[:overview] = movie.overview #On enregistre le synopsis
      for person in Tmdb::Movie.credits(movie.id)["crew"] #Pour chaque personne qui a participé à la réalisation dans le film
        if person["department"] == "Directing" #Si la personne est réalisatrice
          current_movie[:directors] << person["name"] #Alors on l'ajoute dans l'array des réalisateurs
        end
      end
      if movie.poster_path == nil #S'il n'y a pas d'affiche pour le film
        current_movie[:poster] = "http://image.noelshack.com/fichiers/2018/45/4/1541717990-design-3.png"
        #On met une jolie affiche triste que j'ai fait avec amour pour dire qu'aucune affiche n'a pu être trouvée
      else
        current_movie[:poster] = @configuration.base_url + @configuration.poster_sizes[3] + movie.poster_path
        #On construit l'url pour accéder à l'affiche
      end
      results << current_movie
      #On ajoute le film à l'array des résultats
    end
    return results #On retourne les résultats
  end

  def perform(name)
    return search(name)
  end
end
