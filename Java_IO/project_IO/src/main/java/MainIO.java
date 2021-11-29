import java.io.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class MainIO {

    private static File outputDirectory;
    static StringBuilder num_sens_str = new StringBuilder();
    static StringBuilder times_str = new StringBuilder();
    static String time_hms_le = "";
    static String time_astr_le = "";
    static boolean first_write = true;
    static int cntr_hits = 0;
    static int cntr_hits_max = 3;
    static boolean ev_found = false;

    public static void main(String[] args) {
        try {
            File in_f = new File(args[0]);
            File out_f = new File(args[1]);
            String rd_line;
            boolean first_le = true;

            try (BufferedReader reader_obj = new BufferedReader(new InputStreamReader(new FileInputStream(in_f)));
                 BufferedWriter writer_obj = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(out_f)))) {

                try {
                    while ((rd_line = reader_obj.readLine()) != null) {
                        int flags_pattern = Pattern.CASE_INSENSITIVE;
                        Pattern pattern = Pattern.compile("^(LE|HT|EV).*?(\\d+:\\d+:\\d+)\\s+(\\d+,\\d+)\\s+(\\d+)", flags_pattern);
                        Matcher matcher = pattern.matcher(rd_line);

                        if (matcher.find()) {                                                  // инииализация матчинга
                            String curr_num_sens = matcher.group(4);

                            if (rd_line.matches("^[Ee][Vv].*") && !ev_found)            // если нашли event, то вывод как во время LE, пропускаем все последующие Ht и ждём только LE
                                ev_found = true;
                            if (rd_line.matches("^([Ll][Ee]).*")) {                     // обработка поступившей строки если она local event
                                time_hms_le = matcher.group(2);                                // сохранение времен local event в отдельные переменные, т.к. их не нужно выводить в файл, они потребуются только для вычисления временного промежутка до hitа
                                time_astr_le = matcher.group(3);
                                if (!first_le && times_str.length() > 1) {                     // впервые найденный le выводить и обнулять не нужно, поскольку данные ещё не собраны
                                    times_str.deleteCharAt(times_str.length() - 1);            // убрать пробел перед последней ; т.к. заранее знать последний хит, не перейдя к след. строке, мы не можем
                                    if (cntr_hits > cntr_hits_max) {                           // пока недосчитались до 3 хитов, ничего в файл не пишем
                                        writeStr(false, writer_obj);
                                        if (first_write)                                       // запрет записи [ навсегда
                                            first_write = false;
                                    }
                                    num_sens_str.setLength(0);                                 // обнуление строк после обнаружения нового local event'а
                                    times_str.setLength(0);
                                    cntr_hits = 0;
                                }
                                first_le = false;
                                ev_found = false;
                                if (first_write)                                                // Пишем [ всегда при нахождении LE и только если >3 никогда ещё не находилось. Сделано так поскольку строка при определении <3 автоматом очищается. Ведь сразу знать количество hits (>3) мы не можем
                                    num_sens_str.append("[");
                                num_sens_str.append(curr_num_sens).append(" ");                 // накопление номера датчика во время LE события в строку num_sens
//System.out.println("LE" + " " + matcher.group(4) + " " + matcher.group(2) + " " + matcher.group(3));
                            } else if (rd_line.matches("^[Hh][Tt].*") && !ev_found) {    // обработка поступившей строки если она hit
                                cntr_hits++;
                                num_sens_str.append(curr_num_sens).append(" ");                 // накопление номеров датчиков во время Ht событий в строку num_sens
                                times_str.append(handleTime(matcher.group(2), matcher.group(3))).append(" ");
//System.out.println("Ht" + " " + matcher.group(4) + " " + matcher.group(2) + " " + matcher.group(3) + " " + time_hms_le + " " + time_astr_le + " cntr_hits " + cntr_hits);
                            }
                        }
                    }
                    if (first_write) {
                        System.out.println("\nNo data found.\nFile \"" + out_f + "\" is empty.");
                        writer_obj.flush();
                    }
                    else {
                        if (num_sens_str.length() != 0 && times_str.length() != 0) {
                            times_str.deleteCharAt(times_str.length() - 1);
                            if (cntr_hits > cntr_hits_max)
                                writeStr(true, writer_obj);
                            else {
                                writer_obj.write("];");
                                writer_obj.flush();
                            }
                        }
                        System.out.println("\nThe job's is finished.\nResult data in the file \"" + out_f + "\".");
                    }
                } catch (PatternSyntaxException pse) {
                    System.err.println("Неправильное регулярное выражение: " + pse.getMessage());
                    System.err.println("Описание: " + pse.getDescription());
                    System.err.println("Позиция: " + pse.getIndex());
                    System.err.println("Неправильный шаблон: " + pse.getPattern());
                } catch (IllegalStateException e) {
                    System.out.println("No matches for spec pattern!");
                }
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }
        } catch (ArrayIndexOutOfBoundsException aiob) {                         // обнаружение ошибки в параметрах запуска
            System.out.println(aiob);
            if (args.length < 2)
                System.out.println("Start parameters must be > 1!");
        }
    }

    static String handleTime(String time_hms_ht, String time_astr_ht) throws ParseException {
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
//        catch (IllegalArgumentException e) {                                                          // позволяет программе продолжить работу при перехвате throw new IllegalArgumentException()
//            System.out.println(e.getMessage());
//        }
        if (diff_time_ht < 0 || diff_milliseconds > 0)                                                  // обнаружение перехода через секунду относительно ЧМС времени (при миллисекундные значения меняются и их разница може быть < 0)
            System.out.println("Found second jump on \"LE " + time_hms_le + " " + time_astr_le + "\" and \"Ht " + time_hms_ht + " " + time_astr_ht + "\"");

//            if (millisecs.length() > 4)                                                               // нас интересуют только миллисекунды (10^3)
//                millisecs = millisecs.substring(0, 4);
//            return secs + "." + Float.toString(millisecs_le_f) + " ";

        DecimalFormat f = new DecimalFormat("0.0000");                                          // шаблон для последующего перевода астрономических секунд в миллисекунды с округлением
        String out_times_str = f.format((diff_time));
        if (out_times_str.matches(".*\\..*"))                                                    // обнаружение точки (.)
            out_times_str = out_times_str.replace('.', ',');                           // замена точки (.) на запятую (,)

        return out_times_str;
    }

    static void writeStr(boolean is_end_line, BufferedWriter writer) {
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