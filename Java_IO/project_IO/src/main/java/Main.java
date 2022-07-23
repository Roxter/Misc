import java.io.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class Main {

    public static void main(String[] args) throws IOException, ParseException {
            if (args.length != 3) throw new ArrayIndexOutOfBoundsException("\n Start parameters must be = 3!\n"); // обнаружение ошибки в параметрах запуска
            new IO(args);
    }

}

class IO {

    private String[] args;
    private StringBuilder num_sens_str = new StringBuilder();
    private StringBuilder times_str = new StringBuilder();
    private String time_hms_le = "";
    private String time_astr_le = "";
    private int cnt_hits;
    private int cnt_hits_min;
    private int cnt_hits_max_out;
    private int cnt_str = 0;
    private File in_f;
    private File out_f;

    IO(String[] args_from_main) throws IOException, ParseException {                                               // конструктор инициализации переданных аргументов
        args = args_from_main;
        start();
    }

    private void start() throws IOException, ParseException {
        in_f = new File(args[0]);
        Pattern pattern_in_f = Pattern.compile("^(.*\\\\.*?)?(.*?)(\\.txt)");                                      // паттерн поиска имени файла исключая расширение, даже если указана директория
        Matcher matcher_in_f = pattern_in_f.matcher(args[0]);
        matcher_in_f.find();
        out_f = new File("out__" + matcher_in_f.group(2) + "__minHits_" + args[1] + "_maxOutHits_" + args[2] + ".txt");

        cnt_hits_min = Integer.parseInt(args[1]);
        cnt_hits_max_out = Integer.parseInt(args[2]);

        BufferedReader reader_obj = new BufferedReader(new InputStreamReader(new FileInputStream(in_f)));
        BufferedWriter writer_obj = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(out_f)));
        runStream(reader_obj, writer_obj);

        writer_obj.close();
        Pattern pattern_out_f = Pattern.compile("^(.*?)(\\.txt)");                                                 // паттерн поиска имени файла исключая расширение
        Matcher matcher_out_f = pattern_out_f.matcher(out_f.getName());
        matcher_out_f.find();
        File out_f_new = new File(matcher_out_f.group(1) + "_str_" + cnt_str + ".txt");
        out_f.renameTo(out_f_new);                                                                                 // добавляем к имени файла число полученных строк для удобства
    }

    private void runStream (BufferedReader reader_obj, BufferedWriter writer_obj) throws IOException, ParseException {
        String rd_line;
        boolean first_le = true;
        boolean first_write = true;
        boolean ev_found = false;

        try {
            while ((rd_line = reader_obj.readLine()) != null) {
                int flags_pattern = Pattern.CASE_INSENSITIVE;
                Pattern pattern_rd_line = Pattern.compile("^(LE|HT|EV).*?(\\d+:\\d+:\\d+)\\s+(\\d+,\\d+)\\s+(\\d+)", flags_pattern);
                Matcher matcher_rd_line = pattern_rd_line.matcher(rd_line);

                if (matcher_rd_line.find()) {                                          // инииализация матчинга
                    String curr_num_sens = matcher_rd_line.group(4);

                    if (rd_line.matches("^[Ee][Vv].*") && !ev_found)            // если нашли event, то вывод как во время LE, пропускаем все последующие Ht и ждём только LE
                        ev_found = true;
                    if (rd_line.matches("^([Ll][Ee]).*")) {                     // обработка поступившей строки если она local event
                        time_hms_le = matcher_rd_line.group(2);                        // сохранение времен local event в отдельные переменные, т.к. их не нужно выводить в файл, они потребуются только для вычисления временного промежутка до hitа
                        time_astr_le = matcher_rd_line.group(3);
                        if (!first_le && times_str.length() > 1) {                     // впервые найденный le выводить и обнулять не нужно, поскольку данные ещё не собраны
                            times_str.deleteCharAt(times_str.length() - 1);            // убрать пробел перед последней ; т.к. заранее знать последний хит, не перейдя к след. строке, мы не можем
                            if (cnt_hits > cnt_hits_min) {                            // пока недосчитались до 3 хитов, ничего в файл не пишем
                                writeStr(false, writer_obj);
                                if (first_write)                                       // запрет записи [ навсегда
                                    first_write = false;
                            }
                            num_sens_str.setLength(0);                                 // обнуление строк после обнаружения нового local event'а
                            times_str.setLength(0);
                            cnt_hits = 0;
                        }
                        first_le = false;
                        ev_found = false;
                        if (first_write)                                                // пишем [ всегда при нахождении LE и только если >3 никогда ещё не находилось. Сделано так поскольку строка при определении <3 автоматом очищается. Ведь сразу знать количество hits (>3) мы не можем
                            num_sens_str.append("[");
                        if (cnt_hits <= cnt_hits_max_out && cnt_hits_max_out > 0)       // если задано ограничение в количестве датчиков на вывод
                            num_sens_str.append(curr_num_sens).append(" ");             // накопление номера датчика во время LE события в строку num_sens
    //System.out.println("LE" + " " + matcher_rd_line.group(4) + " " + matcher_rd_line.group(2) + " " + matcher_rd_line.group(3));
                    } else if (rd_line.matches("^[Hh][Tt].*") && !ev_found) {    // обработка поступившей строки если она hit
                        cnt_hits++;
                        if (cnt_hits <= cnt_hits_max_out && cnt_hits_max_out > 0) {    // если задано ограничение в количестве датчиков на вывод
                            num_sens_str.append(curr_num_sens).append(" ");             // накопление номеров датчиков во время Ht событий в строку num_sens
                            times_str.append(handleTime(matcher_rd_line.group(2), matcher_rd_line.group(3))).append(" ");
                        }
    //System.out.println("Ht" + " " + matcher_rd_line.group(4) + " " + matcher_rd_line.group(2) + " " + matcher_rd_line.group(3) + " " + time_hms_le + " " + time_astr_le + " cntr_hits " + cntr_hits);
                    }
                }
            }
            if (first_write) {
                System.out.println("\nNo data found.\nFile \"" + out_f + "\" is empty.");
                writer_obj.flush();
            }
            else {
                if (num_sens_str.length() != 0 && times_str.length() != 0) {            // если вдруг во входном файле ничего не найдено, то в выход ничего не пишем
                    times_str.deleteCharAt(times_str.length() - 1);
                    if (cnt_hits > cnt_hits_min)
                        writeStr(true, writer_obj);
                    else {
                        writer_obj.write("];");
                        writer_obj.flush();
                    }
                }
                System.out.println("\nThe job's is finished.\nResult data in the file \"" + out_f + "\".");
            }
        } catch (PatternSyntaxException pse) {                                          // исключение в случае несоответствия паттерну
            System.err.println("Неправильное регулярное выражение: " + pse.getMessage());
            System.err.println("Описание: " + pse.getDescription());
            System.err.println("Позиция: " + pse.getIndex());
            System.err.println("Неправильный шаблон: " + pse.getPattern());
        } catch (IllegalStateException e) {
            System.out.println("No matches for spec pattern!");
        }
    }

    private String handleTime(String time_hms_ht, String time_astr_ht) throws ParseException {
        // перевод секунд
        SimpleDateFormat hms = new SimpleDateFormat("HH:mm:ss", Locale.ENGLISH);                  // шаблон для последующего перевода времени в паттерн типа SimpleDateFormat
        Date time_hms_le_date = hms.parse(time_hms_le);                                                  // перевод вх. временнОй строки в тип Date на основании паттерна "HH:mm:ss"
        Date time_hms_ht_date = hms.parse(time_hms_ht);
        long diff_milliseconds = time_hms_ht_date.getTime() - time_hms_le_date.getTime();                // перевод ЧМС в мс, сразу фиксируем разницу
////            long diff = TimeUnit.SECONDS.convert(diff_hms, TimeUnit.MILLISECONDS);                   // альтернативный вариант перевода
//        long diff_seconds = TimeUnit.MILLISECONDS.toSeconds(diff_milliseconds);                        // перевод миллисекунд в секунды

        // перевод астрономических секунд в миллисекунды

        if (time_astr_le.matches(".*,.*"))                                                         // обнаружение запятой (,) для LE
            time_astr_le = time_astr_le.replace(',', '.');                               // замена запятой (,) на точку (.)
        if (time_astr_ht.matches(".*,.*"))                                                         // обнаружение запятой (,) для HT
            time_astr_ht = time_astr_ht.replace(',', '.');                               // замена запятой (,) на точку (.)
        float time_astr_le_f = Float.parseFloat(time_astr_le);                                           // преобразование строки миллисекунд в вещественный числовой тип float
        float time_astr_ht_f = Float.parseFloat(time_astr_ht);
        float diff_time_ht = time_astr_ht_f - time_astr_le_f;
        float diff_time = diff_milliseconds + diff_time_ht;

//        try {
        if (diff_time < 0)                                                                              // разница абсолютного времени в секундах не должна быть < 0, иначе ошибка
            throw new IllegalArgumentException("\n Program emergency fault!\n Found is a negative HMS time on \"LE " + time_hms_le + " " + time_astr_le + "\" and \"Ht " + time_hms_ht + " " + time_astr_ht + "\" times.\n Incorrect data is not displayed.");
        else if (diff_milliseconds < 0)                                                                 // разница ЧМС времени не должна быть < 0, иначе ошибка
            throw new IllegalArgumentException("\n Program emergency fault!\n Found is a negative Milliseconds on \"LE " + time_hms_le + " " + time_astr_le + "\" and \"Ht " + time_hms_ht + " " + time_astr_ht + "\" times.\n Incorrect data is not displayed.");
//            }
//        catch (IllegalArgumentException e) {                                                          // позволяет программе продолжить выполнение строк после catch при перехвате throw new IllegalArgumentException()
//            System.out.println(e.getMessage());
//        }
        if (diff_time_ht < 0 || diff_milliseconds > 0)                                                  // обнаружение перехода через секунду относительно ЧМС времени (при миллисекундные значения меняются и их разница може быть < 0)
            System.out.println("Found seconds jump on \"LE " + time_hms_le + " " + time_astr_le + "\" and \"Ht " + time_hms_ht + " " + time_astr_ht + "\"");

//            if (millisecs.length() > 4)                                                               // нас интересуют только миллисекунды (10^3)
//                millisecs = millisecs.substring(0, 4);
//            return secs + "." + Float.toString(millisecs_le_f) + " ";

        DecimalFormat f = new DecimalFormat("0.0000");                                          // шаблон для последующего перевода астрономических секунд в миллисекунды с округлением
        String out_times_str = f.format((diff_time));
        if (out_times_str.matches(".*\\..*"))                                                    // обнаружение точки (.)
            out_times_str = out_times_str.replace('.', ',');                           // замена точки (.) на запятую (,)

        return out_times_str;
    }

    private void writeStr(boolean is_end_line, BufferedWriter writer) {
        String str;

        try {
            str = num_sens_str + "" + times_str;
            if (is_end_line)
                str = str + "];";
            else
                str = str + ";";

//System.out.println("writeStr" + " " + str);
            for (int i = 0; i < str.length(); i++)
                writer.write(str.charAt(i));                                                            // посимвольная запись в файл собранной строки str
            cnt_str++;
            if (!is_end_line) {
                writer.write("\n");
            } else {
                writer.flush();
            }
        } catch (IOException io) {
            System.out.println("Exception:" + io);
        }
    }

}