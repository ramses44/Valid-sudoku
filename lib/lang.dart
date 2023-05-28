List<String> languages = ['EN', 'RU'];

Map labels = {
  'Language name': {
    'EN': 'English',
    'RU': 'Русский'
  },
  'Program name': {
    'EN': 'Valid Sudoku',
    'RU': 'Судоку'
  },
  'Select size': {
    'EN': 'Select size',
    'RU': 'Выберите размер'
  },
  'Warning!': {
    'EN': 'Warning!',
    'RU': 'Внимание!'
  },
  'Generating a 16 x 16 Sudoku can take a long time': {
    'EN': 'Generating a 16 x 16 Sudoku can take a long time',
    'RU': 'Генерация Судоку 16 х 16 может занять длительное время'
  },
  'OK': {
    'EN': 'OK',
    'RU': 'ОК'
  },
  'Select difficulty': {
    'EN': 'Select difficulty',
    'RU': 'Выберите уровень сложности'
  },
  'Start game': {
    'EN': 'Start game',
    'RU': 'Начать игру'
  },
  'Continue': {
    'EN': 'Continue',
    'RU': 'Продолжить'
  },
  'Game on pause!': {
    'EN': 'Game on pause!',
    'RU': 'Игра на паузе!'
  },
  'You have solved this sudoku': {
    'EN': 'You have solved this sudoku',
    'RU': 'Вы решили это судоку'
  },
  'Congratulations!': {
    'EN': 'Congratulations!',
    'RU': 'Поздравляем!'
  },
  'Mistakes': {
    'EN': 'Mistakes',
    'RU': 'Ошибок'
  },
  'Hints used': {
    'EN': 'Hints used',
    'RU': 'Подсказок использовано'
  },
  'Erase': {
    'EN': 'Erase',
    'RU': 'Ластик'
  },
  'Notes': {
    'EN': 'Notes',
    'RU': 'Заметки'
  },
  'Hint': {
    'EN': 'Hint',
    'RU': 'Подсказка'
  },
  'Settings': {
    'EN': 'Settings',
    'RU': 'Настройки'
  },
  'Language': {
    'EN': 'Language',
    'RU': 'Язык'
  },
  'Realtime mistakes check': {
    'EN': 'Realtime mistakes check',
    'RU': 'Проверка ошибок во время решения'
  },
  'Yes': {
    'EN': 'Yes',
    'RU': 'Да'
  },
  'No': {
    'EN': 'No',
    'RU': 'Нет'
  },

  'Easy': {
    'EN': 'Easy',
    'RU': 'Легкий'
  },

  'Medium': {
    'EN': 'Medium',
    'RU': 'Средний'
  },

  'Hard': {
    'EN': 'Hard',
    'RU': 'Сложный'
  },

  'Theme': {
    'EN': 'Theme',
    'RU': 'Тема'
  },

  'classic': {
    'EN': 'Classic',
    'RU': 'Классическая'
  },

  'dark': {
    'EN': 'Dark',
    'RU': 'Тёмная'
  },

  'mint': {
    'EN': 'Mint',
    'RU': 'Мятная'
  },

  'Statistics': {
    'EN': 'Statistics',
    'RU': 'Статистика'
  },

  'All': {
    'EN': 'All',
    'RU': 'Все'
  },

  'Total games': {
    'EN': 'Total games',
    'RU': 'Всего игр'
  },

  'Sudoku solved': {
    'EN': 'Sudoku solved',
    'RU': 'Судоку разгадано'
  },

  'Average time': {
    'EN': 'Average time',
    'RU': 'Среднее время'
  },

  'Total hints taken': {
    'EN': 'Total hints taken',
    'RU': 'Всего подсказок взято'
  },

  'Average mistakes count': {
    'EN': 'Average mistakes count',
    'RU': 'В среднем ошибок'
  },

  'Info': {
    'EN': 'Info',
    'RU': 'Инфо'
  },

  'About text': {
    'EN': 'Application "Valid Sudoku".\n\n'
          'It was developed as part of a course project by Roman Sakharov, a student of the Faculty of Computer Science at the Higher School of Economics \n\n'
          'Application source code: https://github.com/ramses44/Valid-sudoku',
    'RU': 'Приложение «Валидное судоку».\n\n'
          'Было разработано в рамках курсового проекта студентом факультета компьютерных наук НИУ ВШЭ Сахаровым Романом \n\n'
          'Исходный код приложения: https://github.com/ramses44/Valid-sudoku'
  },

  'Rules text': {
    'EN': 'Game rules: \n\n'
          'The playing field is a 9×9 square, divided into smaller squares with a side of 3 cells. Thus, the entire playing field consists of 81 cells. In them already at the beginning of the game there are some numbers (from 1 to 9), called hints. The player is required to fill in the free cells with numbers from 1 to 9 so that in each row, in each column and in each small 3 × 3 square, each number would occur only once. \n\n'
          'The complexity of Sudoku depends on the number of initially filled cells and on the methods that need to be applied to solve it. The simplest ones are solved deductively: there is always at least one cell where only one number fits. Some puzzles can be solved in minutes, others can take hours. \n\n'
          'A correctly composed puzzle has only one solution.',
    'RU': 'Правила игры: \n\n'
          'Игровое поле представляет собой квадрат размером 9×9, разделённый на меньшие квадраты со стороной в 3 клетки. Таким образом, всё игровое поле состоит из 81 клетки. В них уже в начале игры стоят некоторые числа (от 1 до 9), называемые подсказками. От игрока требуется заполнить свободные клетки цифрами от 1 до 9 так, чтобы в каждой строке, в каждом столбце и в каждом малом квадрате 3×3 каждая цифра встречалась бы только один раз.\n\n'
          'Сложность судоку зависит от количества изначально заполненных клеток и от методов, которые нужно применять для её решения. Самые простые решаются дедуктивно: всегда есть хотя бы одна клетка, куда подходит только одно число. Некоторые головоломки можно решить за несколько минут, на другие можно потратить часы.\n\n'
          'Правильно составленная головоломка имеет только одно решение.'
  },
};