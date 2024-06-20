package com.jsp.jsp_demo.util.string;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CodingErrorAction;
import java.text.DecimalFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/*
 * The type String util.
 */
public class StringUtil {
    public static final String NULL = "";
    public static final String CRLF = "\n";
    public static final String WHITE_SPACE = " ";

    public String s1;
    public String s2;


    private List<String> getNGram(String[] tokens, int n, List<String> ngrams) {
        StringBuilder strbldr = new StringBuilder();
        if (tokens.length < n) {
            return ngrams;
        } else {
            for (int i = 0; i < n; i++) {
                strbldr.append(tokens[i]).append(" ");
            }
            ngrams.add(strbldr.toString().trim());
            String[] newTokens = Arrays.copyOfRange(tokens, 1, tokens.length);
            return getNGram(newTokens, n, ngrams);
        }
    }

    /**
     * @param maxGramSize should be 1 at least
     * @return set of continuous word n-grams up to maxGramSize from the sentence
     */
    public static List<String> generateNgramsUpto(String str, int maxGramSize) {
        List<String> sentence = Arrays.asList(str.split("[\\W+]"));
        List<String> ngrams = new ArrayList<String>();
        int ngramSize = 0;
        StringBuilder sb = null;
        //sentence becomes ngrams
        for (ListIterator<String> it = sentence.listIterator(); it.hasNext(); ) {
            String word = (String) it.next();
            //1- add the word itself
            sb = new StringBuilder(word);
            ngrams.add(word);
            ngramSize = 1;
            it.previous();
            //2- insert prevs of the word and add those too
            while (it.hasPrevious() && ngramSize < maxGramSize) {
                sb.insert(0, ' ');
                sb.insert(0, it.previous());
                ngrams.add(sb.toString());
                ngramSize++;
            }
            //go back to initial position
            while (ngramSize > 0) {
                ngramSize--;
                it.next();
            }
        }
        return ngrams;
    }


    public static String removeSpaceChar(String data) throws Throwable {
        String result = "";
        if(isNotEmpty(data)) {
            result = data.replaceAll("\\s+", " ");
            // 처리 [&nbsp;]
            result = result.replaceAll("&nbsp;", "");
            result = removeHTMLTag(result);
        }
        return result;
    }

    public static String reformatter(String data) throws Throwable {
        String result = "";
        if (isNotEmpty(data)) {
            result = data.replaceAll("\\s+", " ");
            result = result.replaceAll("&nbsp;", "");
            result = removeHTMLTag(result);
        }
        return result;
    }

    public static String removeHTMLTag(String html) throws Throwable {
        return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    }

    // 문자열 인코딩을 고려해서 문자열 자르기
    public static String substring4Korean(String parameterName, int maxLength) {
        int DB_FIELD_LENGTH = maxLength;

        Charset utf8Charset = Charset.forName("UTF-8");
        CharsetDecoder cd = utf8Charset.newDecoder();

        try {
            byte[] sba = parameterName.getBytes("UTF-8");
            // Ensure truncating by having byte buffer = DB_FIELD_LENGTH
            ByteBuffer bb = ByteBuffer.wrap(sba, 0, DB_FIELD_LENGTH); // len in [B]
            CharBuffer cb = CharBuffer.allocate(DB_FIELD_LENGTH); // len in [char] <= # [B]
            // Ignore an incomplete character
            cd.onMalformedInput(CodingErrorAction.IGNORE);
            cd.decode(bb, cb, true);
            cd.flush(cb);
            parameterName = new String(cb.array(), 0, cb.position());
        }
        catch (UnsupportedEncodingException e) {
            System.err.println("### 지원하지 않는 인코딩입니다." + e);
        }
        return parameterName;
    }

    // 문자열 인코딩에 따라서 글자수 체크
    public static int length4Encoding(CharSequence sequence) {
        int count = 0;
        for (int i = 0, len = sequence.length(); i < len; i++) {
            char ch = sequence.charAt(i);
            if (ch <= 0x7F) {
                count++;
            }
            else if (ch <= 0x7FF) {
                count += 2;
            }
            else if (Character.isHighSurrogate(ch)) {
                count += 4;
                ++i;
            }
            else {
                count += 3;
            }
        }
        return count;
    }

    /* 휴대폰 번호 '-' 생성 */
    public static String makePhoneNumber(String phoneNoStr) {
        String regEx = "(\\d{3,4})(\\d{3,4})(\\d{4})";
        if(!Pattern.matches(regEx, phoneNoStr)) return phoneNoStr;
        return phoneNoStr.replaceAll(regEx, "$1-$2-$3");
    }

    public static boolean isNumberic(String s) { //숫자 판별 함수
        try {
            Double.parseDouble(s);
            return true;
        }
        catch (NumberFormatException e) {  //문자열이 나타내는 숫자와 일치하지 않는 타입의 숫자로 변환 시 발생
            return false;
        }
    }

    //Double.parseDouble(str)
    public static Integer toInteger(String s) {
        Double iTrans;
        Integer rslt;
        try {
            iTrans = Double.parseDouble(s);
            rslt = iTrans.intValue();
        }
        catch (NumberFormatException e) {
            rslt = 0;
        }
        return rslt;
    }


    public static boolean isInteger(String s) { //정수 판별 함수
        try {
            Integer.parseInt(s);
            return true;
        }
        catch(NumberFormatException e) {  //문자열이 나타내는 숫자와 일치하지 않는 타입의 숫자로 변환 시 발생
            return false;
        }
    }

    /*
     *
     *
     * byte단위로 문자열을 자르는 함수
     *  - 2바이트, 3바이트 문자열이 잘리는 부분은 제거 (한글 등)
     *  - 자르고 뒤에 ' ......' 을 붙인다.
     *
     *
     * @param str : 자를 문자열
     * @param cutlen : 자를 바이트 수
     * @return 자르고 뒤에 ...을 붙인 문자열
     */
    public static String subStrByte(String str, int cutlen) {
        if(isNotEmpty(str)) {
            str = str.trim();
            if(str.getBytes().length <= cutlen) {
                return str;
            }
            else {
                StringBuffer sbStr = new StringBuffer(cutlen);
                int nCnt = 0;
                for(char ch: str.toCharArray()) {
                    nCnt += String.valueOf(ch).getBytes().length;
                    if(nCnt > cutlen)  break;
                    sbStr.append(ch);
                }
                return sbStr.toString() + "  ...... ";
            }
        }
        else {
            return "";
        }
    }

    /*
     * Gets process time.
     *
     * @param nStart the n start
     * @param nEnd   the n end
     * @return the process time
     */
    @SuppressWarnings("static-access")
    public static String getProcessTime(long nStart, long nEnd) {
        Date proccessingdt = new Date(nEnd - nStart);
        Calendar cal = Calendar.getInstance();
        cal.setTime(proccessingdt);
        String sProcessTime = cal.get(cal.MINUTE) + "m " + cal.get(cal.SECOND) + "s " + cal.get(cal.MILLISECOND) + "ms";
        return sProcessTime;
    }

    /*
     * Is number validate boolean.
     *
     * @param s the s
     * @return the boolean
     */
    public static boolean isNumberValidate(String s) {
        try {
            Double.parseDouble(s);
            //System.err.println("@isNumberValidate : "+s+" --> [true]");
            return true;
        }
        catch(NumberFormatException e) {
            //System.err.println("@isNumberValidate : NumberFormatException : "+s);
            return false;
        }
    }

    public static boolean isNumberValidate(Integer i) {
        try {
            Double.parseDouble(String.valueOf(i));
            //System.err.println("@isNumberValidate : "+i+" --> [true]");
            return true;
        }
        catch(NumberFormatException e) {
            //System.err.println("@isNumberValidate : NumberFormatException : "+i);
            return false;
        }
    }

    /*
     * Nvl str string.
     *
     * @param src     the src
     * @param initStr the init str
     * @return the string
     */
    public static String nvlStr(Object src, String initStr)
    {
        if(src == null)
            return initStr ;
        else
            return src.toString();
    }

    /*
     * Number format with comma string.
     *
     * @param resource the resource
     * @return the string
     */
    public static String numberFormatWithComma(String resource) {
        String Result = null;
        try {
            if(resource != null && !"".equals(resource)) {
                if(isNumberValidate(resource)) {
                    int number = Integer.parseInt(resource);
                    DecimalFormat df = new DecimalFormat("#,###");
                    Result = df.format(number);
                }
            }
        }
        catch(Exception e) {}
        return Result;
    }

    /*
     * Number format with comma string.
     *
     * @param resource the resource
     * @return the string
     */
    public static String numberFormatWithComma(Integer resource) {
        String Result = null;
        try {
            if(resource != null && !"".equals(resource)) {
                int number = resource;
                DecimalFormat df = new DecimalFormat("#,###");
                Result = df.format(number);
            }
        }
        catch(Exception e) {}
        return Result;
    }

    /*
     * Number format with comma string.
     *
     * @param resource the resource
     * @return the string
     */
    public static String dateFormatWithString(String resource) {
        String Result = null;
        try {
            if(resource != null && !"".equals(resource)) {
                if(isNumberValidate(resource)) {
                    if (resource.length() == 6) {
                        Result = resource.substring(0, 4) + "-" + resource.substring(4, 6);
                    }
                    if (resource.length() == 8) {
                        Result = resource.substring(0, 4) + "-" + resource.substring(4, 6) + "-" + resource.substring(6, 8);
                    }
                }
            }
        }
        catch(Exception e) {}
        return Result;
    }

    /*
     * Gets param.
     *
     * @param p            the p
     * @param defaultValue the default value
     * @return the param
     */
    public static String getParam(String p, String defaultValue) {
        return (p == null || p.trim().equals("")) ? defaultValue : p.trim();
    }

    /*
     * Gets no length str.
     *
     * @param p            the p
     * @param defaultValue the default value
     * @return the no length str
     */
    public static String getNoLengthStr(String p, String defaultValue) {
        return (p.length() == 0) ? defaultValue : p;
    }

    /*
     * Is empty str boolean.
     *
     * @param p the p
     * @return the boolean
     */
    public static boolean isEmptyStr(String p) {
        return (p == null || p.trim().equals("") || p.trim().equals("null") );
    }

    /*
     * Gets selected option.
     *
     * @param pordField the pord field
     * @param matchkey  the matchkey
     * @param dispName  the disp name
     * @return the selected option
     */
    public static String getSelectedOption(String pordField, String matchkey, String dispName) {
        StringBuilder sb = new StringBuilder();

        sb.append("<option value=\"");
        sb.append(matchkey);
        sb.append("\"");

        if (pordField.equalsIgnoreCase(matchkey))
            sb.append(" selected>");
        else
            sb.append(">");

        sb.append(dispName);
        sb.append("</option>");

        String rtn = sb.toString();
        sb.setLength(0);
        sb = null;

        return rtn;
    }

    /*
     * Gets exception trace.
     *
     * @param ee the ee
     * @return the exception trace
     */
    public static String getExceptionTrace(Exception ee) {
        String rtn = "";
        try {
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);

            // ee.printStackTrace(pw);

            rtn = sw.toString();

            pw.close();
            sw.close();

        } catch (java.io.IOException ioe) {
            rtn = "getExceptionTrace(Exception ee) : " + ioe.toString();
        }
        return rtn;
    }

    /*
     * Gets error trace.
     *
     * @param err the err
     * @return the error trace
     */
    public static String getErrorTrace(Error err) {
        String rtn = "";
        try {
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);

            // err.printStackTrace(pw);

            rtn = sw.toString();

            pw.close();
            sw.close();

        } catch (java.io.IOException ioe) {
            rtn = "getExceptionTrace(Exception ee) : " + ioe.toString();
        }
        return rtn;
    }

    /*
     * To kor string.
     *
     * @param p the p
     * @return the string
     */
    public static String toKor(String p) {
        return toKor(p, "euc-kr");
    }

    /*
     * To kor string.
     *
     * @param p        the p
     * @param encoding the encoding
     * @return the string
     */
    public static String toKor(String p, String encoding) {
        try {
            return new String(p.getBytes("8859_1"), encoding);
        } catch (UnsupportedEncodingException uee) {
            return uee.toString();
        }
    }

    /*
     * Xml encode string.
     *
     * @param str the str
     * @return the string
     */
    public static String xmlEncode(String str) {
        if (str == null || str.trim().equals(""))
            str = "";

        // 변환 결과물을 담을 변수
        String cvt = str.trim();

        cvt = cvt.replaceAll("&", "&amp;");
        cvt = cvt.replaceAll("<", "&lt;");
        cvt = cvt.replaceAll(">", "&gt;");
        cvt = cvt.replaceAll("\"", "&quot;");
        return cvt;
    }

    /*
     * Hdml encode for common xml string.
     *
     * @param xmlEncodedStr the xml encoded str
     * @return the string
     */
    public static String hdmlEncodeForCommonXml(String xmlEncodedStr) {
        if (xmlEncodedStr == null || xmlEncodedStr.trim().equals(""))
            xmlEncodedStr = "";

        String cvt = xmlEncodedStr.trim();

        cvt = replacement(cvt, "&amp;", "&amp;amp;");
        cvt = replacement(cvt, "&lt;", "&amp;lt;");
        cvt = replacement(cvt, "&gt;", "&amp;gt;");
        cvt = replacement(cvt, "&quot;", "&amp;quot;");
        cvt = replacement(cvt, "$", "&amp;dol;");
        return cvt;
    }

    /*
     * Convert to javascript str string.
     *
     * @param s the s
     * @return the string
     */
    public static String convertToJavascriptStr(String s) {
        String rtn = s;
        rtn = replacement(rtn, "\\", "\\\\");
        rtn = replacement(rtn, "\"", "\\\"");
        rtn = replacement(rtn, "\t", "\\\t");
        rtn = replacement(rtn, "\n", "\\\n");
        rtn = replacement(rtn, "\r", "\\\r");
        return rtn;
    }

    /*
     * Gets htmlized contents.
     *
     * @param strCONTENT the str contents
     * @return the htmlized contents
     */
    public static String getHtmlizedContent(String strCONTENT) {
        String s = strCONTENT;
        s = replacement(s, "\n", "<br/>");
        s = replacement(s, "\t", "&nbsp;&nbsp;");
        s = replacement(s, "\r", "");
        s = replacement(s, "\\", "￦");
        s = replacement(s, "\"", "&quot;");
        s = substring2(s, 25);
        return s;
    }

    /*
     * Replacement string.
     *
     * @param source the source
     * @param find   the find
     * @param dest   the dest
     * @return the string
     */
    public static String replacement(String source, String find, String dest) {
        return replacement(source, find, dest, 0);
    }

    /*
     * Replacement string.
     *
     * @param source        the source
     * @param find          the find
     * @param dest          the dest
     * @param startPosition the start position
     * @return the string
     */
    public static String replacement(String source, String find, String dest,
                                     int startPosition) {
        if (source == null || source.length() <= 0) {
            return "";
        }

        if (find == null || find.length() <= 0) {
            return source;
        }

        if (dest == null) {
            dest = "";
        }

        String result = "";

        int first = 0;
        int next = 0;

        next = source.indexOf(find, startPosition);
        if (next < 0) {
            return source;
        }

        while (next >= startPosition) {
            result += source.substring(first, next);
            result += dest;

            first = next + find.length();
            next = source.indexOf(find, first);
        }

        if (first < source.length()) {
            result += source.substring(first);
        }
        return result;
    }

    /*
     * Gets cut string.
     *
     * @param str        the str
     * @param maxbytelen the maxbytelen
     * @return the cut string
     */
    public static String getCutString(String str, int maxbytelen) {
        if (getByteLength(str) <= maxbytelen)
            return str;

        StringBuilder sb = new StringBuilder();
        int nCurrBytes = 0; // 현재까지의 바이트수
        for (int i = 0; i < str.length(); i++) {
            String ch = str.substring(i, i + 1); // get a char
            // 현재까지의 바이트수에 현 글자바이트수를 더해봐서 maxbytelen보다 작은지 검사
            if ((nCurrBytes + ch.getBytes().length) <= maxbytelen) {
                sb.append(ch);
                nCurrBytes += ch.getBytes().length;
            } else
                break;
        }
        String rtn = sb.toString();
        // clear buffer
        sb.setLength(0);
        sb = null;
        return (rtn.substring(0, rtn.length() - 2) + "..");
    }

    /*
     * Gets cut string.
     *
     * @param str        the str
     * @param maxbytelen the maxbytelen
     * @return the cut string
     */
    public static String getCutString4validationJs(String str, int maxbytelen) {
        if (getByteLength4validationJs(str) <= maxbytelen)
            return str;

        StringBuilder sb = new StringBuilder();
        int nCurrBytes = 0; // 현재까지의 바이트수
        for (int i = 0; i < str.length(); i++) {
            String ch = str.substring(i, i + 1); // get a char
            // 현재까지의 바이트수에 현 글자바이트수를 더해봐서 maxbytelen보다 작은지 검사
            if ((nCurrBytes + getByteLength4validationJs(ch) <= maxbytelen)) {
                sb.append(ch);
                nCurrBytes += getByteLength4validationJs(ch);
            } else
                break;
        }
        String rtn = sb.toString();
        // clear buffer
        sb.setLength(0);
        sb = null;
        return (rtn + "..");
    }

    /*
     * Gets byte length.
     *
     * @param str the str
     * @return the byte length
     */
    public static int getByteLength(String str) {
        return (str == null || str.equals("")) ? 0 : str.getBytes().length;
    }

    public static int getByteLength4validationJs(String src) {
        int length = 0;
        for (int i = 0; i < src.length(); i++) {
            char ch = src.charAt(i);
            length += ((ch & 0xff00) != 0 ? 3 : 1);
        }
        return length;
    }

    /*
     * Gets string to integer.
     *
     * @param str the str
     * @return the string to integer
     */
    public static int getStringToInteger(String str) {
        return (str == null || str.equals("")) ? 0 : Integer.parseInt(str);
    }

    /*
     * Trim char string.
     *
     * @param str the str
     * @param ch  the ch
     * @return the string
     */
    public static String trimChar(String str, String ch) {
        if (str == null || str.equals(""))
            return "";

        String strChar = ch;
        while (str.startsWith(strChar))
            str = str.substring(1);

        while (str.endsWith(strChar))
            str = str.substring(0, str.length() - 1);

        return str;
    }

    /*
     * Trim char string.
     *
     * @param str the str
     * @param ch  the ch
     * @return the string
     */
    public static String trimChar(String str, char ch) {
        return trimChar(str, "" + ch);
    }

    /*
     * Trim quote string.
     *
     * @param str the str
     * @return the string
     */
    public static String trimQuote(String str) {
        return trimChar(str, "\"");
    }

    /*
     * Ml encode string.
     *
     * @param str the str
     * @param ml  the ml
     * @return the string
     */
    public static String mlEncode(String str, String ml) {
        if (str == null || str.trim().equals(""))
            return "";

        if (ml.toUpperCase().equals("WML")) {
            // WML
            str = replacement(str, "&amp;", "&");
            str = replacement(str, "&", "&amp;");
            str = replacement(str, "<", "&lt;");
            str = replacement(str, ">", "&gt;");
            str = replacement(str, "'", "&apos;");
            str = replacement(str, "\"", "&quot;");
            str = replacement(str, "$", "$$");
        }
        else if (ml.toUpperCase().equals("HDML")) {
            // HDML
            str = replacement(str, "&amp;", "&");
            str = replacement(str, "&", "&amp;");
            str = replacement(str, "<", "&lt;");
            str = replacement(str, ">", "&gt;");
            str = replacement(str, "\"", "&quot;");
            str = replacement(str, "$", "&dol;");
            str = replacement(str, "'", "&#39;");
        }
        else {
            // HTML
            str = replacement(str, "&amp;", "&");
            str = replacement(str, "&", "&amp;");
            str = replacement(str, "<", "&lt;");
            str = replacement(str, ">", "&gt;");
            str = replacement(str, "\"", "&quot;");
            // str = replacement(str, "'", "&#39;");

            str = replacement(str, "&amp;lt;", "&lt;");
            str = replacement(str, "&amp;gt;", "&gt;");
            str = replacement(str, "&amp;quot;", "&quot;");
            str = replacement(str, "&amp;amp;", "&amp;");
            str = replacement(str, "&amp;#39;", "&#39;");
        }
        return str;
    }

    /*
     * Html encode string.
     *
     * @param str the str
     * @return the string
     */
    public static String htmlEncode(String str) {
        return mlEncode(str, "HTML");
    }

    /*
     * Wml encode string.
     *
     * @param str the str
     * @return the string
     */
    public static String wmlEncode(String str) {
        return mlEncode(str, "WML");
    }

    /*
     * Hdml encode string.
     *
     * @param str the str
     * @return the string
     */
    public static String hdmlEncode(String str) {
        return mlEncode(str, "HDML");
    }

    /*
     * Db encode string.
     *
     * @param str the str
     * @return the string
     */
    public static String dbEncode(String str) {
        return replacement(str, "'", "''");
    }

    /*
     * Gets attribute from url.
     *
     * @param url  the url
     * @param attr the attr
     * @return the attribute from url
     */
    public static String getAttributeFromUrl(String url, String attr) {
        String strAttrKey = attr.toUpperCase() + "=";

        int nStartIndex = url.toUpperCase().indexOf(strAttrKey);
        if (nStartIndex == -1) // can't find attribute
            return "";

        nStartIndex += strAttrKey.length();

        /*
         * url이 ~~~~~~&attr= 로 그냥 값없이 끝나는 경우 ^ nStartIndex
         */
        if (nStartIndex == url.length())
            return "";

        // 다음 attribute 시작 문자 & 를 찾는다.
        int nEndIndex = url.indexOf("&", nStartIndex);

        // 다음 attribute가 없다면
        // 예) ~~~~~~~&attr=value
        if (nEndIndex == -1)
            nEndIndex = url.length(); // to the end of the url line

        if (nStartIndex <= nEndIndex) {
            String rtn = "";
            try {
                rtn = java.net.URLDecoder.decode(url.substring(nStartIndex,
                        nEndIndex), "euc-kr");
            } catch (UnsupportedEncodingException ex) {
            }
            return rtn;
        }
        else {
            return "";
        }
    }

    /*
     * Make fixed size int string.
     *
     * @param intValue the int value
     * @param nSize    the n size
     * @return the string
     */
    public static String makeFixedSizeInt(int intValue, int nSize) {
        return makeFixedSizeInt("" + intValue, nSize);
    }

    /*
     * Make fixed size int string.
     *
     * @param sValue the s value
     * @param nSize  the n size
     * @return the string
     */
    public static String makeFixedSizeInt(String sValue, int nSize) {
        String strValue = sValue;

        int nCurSize = strValue.length();
        if (nCurSize >= nSize)
            return sValue;

        int diff = nSize - nCurSize;
        StringBuilder sb = new StringBuilder(nSize);

        for (int i = 0; i < diff; i++)
            sb.append("0");

        sb.append(strValue);

        String rtn = sb.toString().trim();
        sb.setLength(0);
        sb = null;

        return rtn;
    }

    /*
     * Remove code char string.
     *
     * @param str the str
     * @return the string
     */
    public static String removeCodeChar(String str) {
        return (str == null) ? "" : str.replaceAll("[&][#][0-9]+?[;]", "");
    }

    /*
     * Replace hanja string.
     *
     * @param strText        the str text
     * @param strReplacement the str replacement
     * @return the string
     */
    public static String replaceHanja(String strText, String strReplacement) {
        if (strText == null || strText.equals(""))
            return "";

        StringBuilder buff = new StringBuilder(strText.length());

        for (int i = 0; i < strText.length(); i++) {
            char ch = strText.charAt(i);

            int n = ch;
            if (n >= 0x4E00 && n <= 0x9FA5)
                buff.append(strReplacement);
            else
                buff.append(ch);

            // buff.append(Integer.toHexString(n) + "|"); // 문자의 유니코드를 찍어 보기 위함
        }

        String rtn = buff.toString();
        buff.setLength(0);
        buff = null;

        return rtn;
    }

    /*
     * Remove hanja string.
     *
     * @param strText the str text
     * @return the string
     */
    public static String removeHanja(String strText) {
        return replaceHanja(strText, "");
    }

    /*
     * Html encode for common xml string.
     *
     * @param str the str
     * @return the string
     */
    public static String htmlEncodeForCommonXml(String str) {
        return xmlEncode(str);
    }

    /*
     * Wml encode for common xml string.
     *
     * @param xmlEncodedStr the xml encoded str
     * @return the string
     */
    public String wmlEncodeForCommonXml(String xmlEncodedStr) {
        if (xmlEncodedStr == null || xmlEncodedStr.trim().equals(""))
            xmlEncodedStr = "";

        String cvt = xmlEncodedStr.trim();

        cvt = replacement(cvt, "'", "&apos;");
        cvt = replacement(cvt, "$", "$$");

        return cvt;
    }

    /*
     * Encode text for common xml string.
     *
     * @param xmlEncodedStr the xml encoded str
     * @param sMarkup       the s markup
     * @return the string
     */
    public String encodeTextForCommonXml(String xmlEncodedStr, String sMarkup) {
        if (xmlEncodedStr == null || xmlEncodedStr.trim().equals(""))
            xmlEncodedStr = "";

        String cvt = xmlEncodedStr.trim();

        if (sMarkup.toLowerCase().indexOf("hdml") != -1) {
            // hdml
            return hdmlEncodeForCommonXml(xmlEncodedStr);
        } else if (sMarkup.toLowerCase().indexOf("wml") != -1) {
            // wml
            return wmlEncodeForCommonXml(xmlEncodedStr);
        } else {
            // html
            return cvt;
        }
    }

    /*
     * Gets display phone key.
     *
     * @param pstrPhoneKey the pstr phone key
     * @return the display phone key
     */
    public String getDisplayPhoneKey(String pstrPhoneKey) {
        if (pstrPhoneKey == null || pstrPhoneKey.trim().equals(""))
            return "N/A";

        if (pstrPhoneKey.startsWith("82"))
            pstrPhoneKey = pstrPhoneKey.substring(2);

        if (pstrPhoneKey.length() == 11) {
            pstrPhoneKey = pstrPhoneKey.substring(0, 3) + "-"
                    + pstrPhoneKey.substring(3, 7) + "-"
                    + pstrPhoneKey.substring(7);
        } else if (pstrPhoneKey.length() == 10) {
            pstrPhoneKey = pstrPhoneKey.substring(0, 3) + "-"
                    + pstrPhoneKey.substring(3, 6) + "-"
                    + pstrPhoneKey.substring(6);
        } else {

            if (pstrPhoneKey.indexOf("_airnet019") != -1) {
                pstrPhoneKey = "LGT: "
                        + pstrPhoneKey.substring(0, pstrPhoneKey
                        .indexOf("_airnet019"));
            }
        }
        return pstrPhoneKey;
    }

    /*
     * Substring 2 string.
     *
     * @param str the str
     * @param max the max
     * @return the string
     */
    public static String substring2(String str, int max) {
        if (str == null)
            return "";
        return ((str.length() > max) ? substring(str, max - 1) : str);
    }

    /*
     * Replace html codes string.
     *
     * @param contents the contents
     * @return the string
     */
    public static String replaceHtmlCodes(String contents) {
        // html code to be replaced.
        String htmlCode = "&";
        String htmlCode2 = "<";
        String htmlCode3 = ">";
        String htmlCode4 = "\"";

        // replacement.
        String codeReplacement = "&amp;";
        String codeReplacement2 = "&lt;";
        String codeReplacement3 = "&gt;";
        String codeReplacement4 = "&quot;";

        int indexReplacement = contents.indexOf(htmlCode);
        if (indexReplacement != -1) {
            contents = contents.replaceAll(htmlCode, codeReplacement);
        }

        int indexReplacement2 = contents.indexOf(htmlCode2);
        if (indexReplacement2 != -1) {
            contents = contents.replaceAll(htmlCode2, codeReplacement2);
        }

        int indexReplacement3 = contents.indexOf(htmlCode3);
        if (indexReplacement3 != -1) {
            contents = contents.replaceAll(htmlCode3, codeReplacement3);
        }

        int indexReplacement4 = contents.indexOf(htmlCode4);
        if (indexReplacement4 != -1) {
            contents = contents.replaceAll(htmlCode4, codeReplacement4);
        }

        // carrage return value.
        char[] newLineChar = new char[1];
        newLineChar[0] = (char) 0x000A;
        String newLine = new String(newLineChar);

        int index = contents.indexOf(newLine);
        if (index != -1) {
            contents = contents.replaceAll(newLine, "<BR>");
        }
        return contents;
    }


    /*
     * Substring string.
     *
     * @param str the str
     * @param max the max
     * @return the string
     */
    public static String substring(String str, int max) {
        if (str == null) {
            return "";
        }

        int length = str.length();

        String SUFFIX = "...";

        int limit = length;
        if (length > max) {
            limit = max;
        } else {
            SUFFIX = "";
        }
        str = str.substring(0, limit);
        str += SUFFIX;
        return str;
    }

    /*
     * Gets attribute from line.
     *
     * @param strLine          the str line
     * @param strAttributeName the str attribute name
     * @return the attribute from line
     */
    public static String getAttributeFromLine(String strLine, String strAttributeName) {
        if (strLine == null || strLine.trim().equals("")) {
            return "";
        }
        if (strAttributeName == null || strAttributeName.trim().equals("")) {
            return "";
        }

        int nStartIndex = -1;
        int nEndIndex = -1;

        String strAttrKey = strAttributeName + "=";
        strAttrKey = strAttrKey.toUpperCase();

        nStartIndex = strLine.toUpperCase().indexOf(strAttrKey);
        if (nStartIndex == -1) { // can't find Attribute
            return "";
        }

        nEndIndex = strLine.toUpperCase().indexOf("&", nStartIndex + 1);
        if (nEndIndex == -1) {
            nEndIndex = strLine.length();
        }

        if (nStartIndex < nEndIndex) {
            return strLine.substring(nStartIndex + strAttrKey.length(),
                    nEndIndex);
        }
        return "";
    }

    /*
     * Gets result set dump html string.
     *
     * @param resultSet the result set
     * @return the result set dump html string
     */
    public static String getResultSetDumpHtmlString(java.sql.ResultSet resultSet) {
        if (resultSet == null)
            return "Your ResultSet is null!";
        try {
            java.sql.ResultSetMetaData rsmd = resultSet.getMetaData();
            StringBuilder buff = new StringBuilder();
            int cols = rsmd.getColumnCount();
            buff.append("<table border=1>").append("\n");
            buff.append("<tr>").append("\n");
            for (int i = 0; i < cols; i++) {
                buff.append("<td>" + rsmd.getColumnName((i + 1)) + "</td>")
                        .append("\n");
            }
            buff.append("</tr>").append("\n");
            while (resultSet.next()) {
                buff.append("<tr>").append("\n");
                for (int i = 0; i < cols; i++) {
                    buff
                            .append(
                                    "<td>" + resultSet.getString((i + 1))
                                            + "</td>").append("\n");
                }
                buff.append("</tr>").append("\n");
            }
            buff.append("</table>").append("\n");
            return buff.toString();
        }
        catch (java.sql.SQLException sqle) {
            return getExceptionTrace(sqle);
        }
    }

    /*
     * Gets web output.
     *
     * @param str          the str
     * @param defaultValue the default value
     * @param trimLen      the trim len
     * @param fRemoveHtml  the f remove html
     * @return the web output
     */
    public static String getWebOutput(String str, String defaultValue, int trimLen, boolean fRemoveHtml) {
        String rtn = getParam(str, defaultValue);
        rtn = substring2(rtn, trimLen);
        return (fRemoveHtml) ? replaceHtmlCodes(rtn) : rtn;
    }

    /*
     * Gets web output.
     *
     * @param str          the str
     * @param defaultValue the default value
     * @param trimLen      the trim len
     * @return the web output
     */
    public static String getWebOutput(String str, String defaultValue, int trimLen) {
        return getWebOutput(str, defaultValue, trimLen, true);
    }

    /*
     * Right n pad string.
     *
     * @param src   the src
     * @param c     the c
     * @param total the total
     * @return the string
     */
    public static String rightNPad(String src, char c, int total) {
        String rs = String.format("%s", src);
        int length = total - src.length();
        if (length > 0) {
            for (int i = 0; i < length; i++)
                rs += c;
        }
        return rs;
    }

    /*
     * Disassemble file string [ ].
     *
     * @param fileName the file name
     * @return the string [ ]
     */
    public static String[] disassembleFile(String fileName) {
        int j = fileName.indexOf(".");
        String[] disassembleFile = new String[2];
        if (j == -1) {
            disassembleFile[0] = fileName;
            disassembleFile[1] = "";
        } else {
            disassembleFile[0] = fileName.substring(0, j);
            disassembleFile[1] = fileName.substring(j + 1);
        }
        return disassembleFile;
    }

    /*
     * Lpad string.
     *
     * @param str the str
     * @param len the len
     * @param pad the pad
     * @return the string
     */
    public static String lpad(String str, int len, char pad) {
        String tar = str;
        for (int i = 0; i < len - str.getBytes().length; i++) {
            tar = pad + tar;
        }
        return tar;
    }

    /*
     * Lpad string.
     *
     * @param str the str
     * @param len the len
     * @return the string
     */
    public static String lpad(String str, int len) {
        return lpad(str, len, '0');
    }

    /*
     * Lpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String lpad(int num, int len) {
        return lpad(Integer.toString(num), len, '0');
    }

    /*
     * Lpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String lpad(long num, int len) {
        return lpad(Long.toString(num), len, '0');
    }

    /*
     * Lpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String lpad(double num, int len) {
        return lpad(Double.toString(num), len, '0');
    }

    /*
     * Rpad string.
     *
     * @param src the src
     * @param len the len
     * @param pad the pad
     * @return the string
     */
    public static String rpad(String src, int len, char pad) {
        String tar = src;
        for (int i = src.getBytes().length; i < len; i++) {
            tar = tar + pad;
        }
        return tar;
    }

    /*
     * Rpad string.
     *
     * @param src the src
     * @param len the len
     * @return the string
     */
    public static String rpad(String src, int len) {
        return rpad(src, len, '0');
    }

    /*
     * Rpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String rpad(int num, int len) {
        return rpad(Integer.toString(num), len, '0');
    }

    /*
     * Rpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String rpad(long num, int len) {
        return rpad(Long.toString(num), len, '0');
    }

    /*
     * Rpad string.
     *
     * @param num the num
     * @param len the len
     * @return the string
     */
    public static String rpad(double num, int len) {
        return rpad(Double.toString(num), len, '0');
    }

    /*
     * Round double.
     *
     * @param num the num
     * @param pos the pos
     * @return the double
     */
    public static double round(double num, int pos) {
        return Math.round(num * Math.pow(10, pos)) / Math.pow(10, pos);
    }

    /*
     * Insert char by front string.
     *
     * @param str the str
     * @param chr the chr
     * @param pos the pos
     * @return the string
     */
    public static String insertCharByFront(String str, char chr, int pos) {
        String outMsg = "";
        for (int i = 0; i < str.length(); i++) {
            if (i != 0 && (i % pos == (pos - 1))) {
                outMsg += chr;
            }
            outMsg += str.charAt(i);
        }
        return outMsg;
    }

    /*
     * Insert char by back string.
     *
     * @param str the str
     * @param chr the chr
     * @param pos the pos
     * @return the string
     */
    public static String insertCharByBack(String str, char chr, int pos) {
        String outMsg = "";
        for (int i = 0; i < str.length(); i++) {
            if (i != 0 && (i % pos == str.length() % pos)) {
                outMsg += chr;
            }
            outMsg += str.charAt(i);
        }
        return outMsg;
    }

    /*
     * Insert comma string.
     *
     * @param str the str
     * @return the string
     */
    public static String insertComma(String str) {
        str = str.replaceAll(",", ""); // 컴마를 삭제
        int pos = str.indexOf("."); // 컴마의 위치
        if (pos == -1) {
            return insertCharByFront(str, ',', 3);
        } else {
            String str1 = str.substring(0, pos);
            String str2 = str.substring(pos);
            return insertCharByFront(str1, ',', 3) + str2;
        }
    }

    /*
     * Check special char string.
     *
     * @param str the str
     * @return the string
     */
    public static String checkSpecialChar(String str) {
        return str.replaceAll("\"", "\\\\\"").replaceAll("&lt;", "<")
                .replaceAll("&gt;", ">");
    }

    /*
     * Strip html string.
     *
     * @param str the str
     * @return the string
     */
    public static String stripHTML(String str) {
        StringBuilder sb = new StringBuilder(str);

        int left = 0;
        int right = left;

        while (left != sb.length()) {
            if (sb.charAt(left) == '<') {
                if (sb.charAt(left + 1) == '!' && sb.charAt(left + 2) == '-'
                        && sb.charAt(left + 3) == '-') {
                    right = left + 4;
                    while (sb.charAt(right) != '>'
                            || sb.charAt(right - 1) != '-'
                            || sb.charAt(right - 2) != '-') {
                        right++;
                    }
                    sb.delete(left, right + 1);
                } else {
                    right = left;
                    while (sb.charAt(right) != '>') {
                        right++;
                    }
                    sb.delete(left, right + 1);
                }
            } else if (sb.charAt(left) == '&') {
                right = left;
                while (sb.charAt(right) != ';') {
                    right++;
                }
                sb.delete(left, right + 1);
            } else {
                left++;
            }
        }

        return sb.toString();
    }

    /*
     * Truncate string.
     *
     * @param str the str
     * @param len the len
     * @return the string
     */
    public static String truncate(String str, int len) {
        String ch;
        int cnt = 0, pos = 0;

        while ((pos < str.length()) && (cnt < len - 1)) {
            ch = str.substring(pos, pos + 1);

            if (ch.getBytes().length == 3) {
                cnt = cnt + 3;
            }else if(ch.getBytes().length == 2){
                cnt = cnt + 2;
            } else {
                cnt = cnt + 1;
            }

            pos = pos + 1;
        }

        if (cnt < str.getBytes().length)
            return str.substring(0, pos) + "...";
        else
            return str;
    }

    /*
     * Truncate nvl string.
     *
     * @param str        the str
     * @param len        the len
     * @param defaultMsg the default msg
     * @return the string
     */
    public static String truncateNvl(String str, int len, String defaultMsg) {
        return str == null || "".equals(str) ? defaultMsg: truncate(str, len);
    }

    /*
     * To in parameters string.
     *
     * @param params the params
     * @return the string
     */
    public static String toInParameters(String [] params){

        if ( params == null || params.length == 0 ){
            return "''";
        }
        StringBuilder buffer = new StringBuilder();
        for (int k = 0; k < params.length; k++) {
            buffer.append("'");
            buffer.append(params[k]);
            buffer.append("',");
        }
        if ( buffer.length() > 0 ){
            return buffer.substring(0, buffer.length()-1);
        }
        return buffer.toString();
    }

    /*
     * Str to list list.
     *
     * @param str   the str
     * @param regex the regex
     * @return the list
     */
    public static List strToList(String str, String regex){
        List list = null;
        if ( str == null){
            return null;
        }
        if ( regex == null || regex.length() == 0 ){
            list = new ArrayList();
            list.add(str);
            return list;
        }
        String [] results = str.split(regex);
        if ( results == null ){
            return null;
        }
        list = new ArrayList();
        for (int k = 0; k < results.length; k++) {
            list.add(results[k]);
        }
        return list;
    }

    /*
     * Is contains boolean.
     *
     * @param values the values
     * @param check  the check
     * @return the boolean
     */
    public static boolean isContains(String [] values, String check){
        if ( values == null || values.length == 0 || check == null ){
            return false;
        }
        for (int k = 0; k < values.length; k++) {
            if ( values[k] != null && values[k].equals(check)){
                return true;
            }
        }
        return false;
    }

    /*
     * Is contains boolean.
     *
     * @param values the values
     * @param check  the check
     * @return the boolean
     */
    public static boolean isContains(List values, String check){
        if ( values == null || values.size() == 0 || check == null ){
            return false;
        }
        return isContains((String[]) values.toArray(), check);
    }

    /*
     * Replace null string.
     *
     * @param str          the str
     * @param replaceValue the replace value
     * @return the string
     */
    public static String replaceNull(String str, String replaceValue){

        if(StringUtil.isEmptyStr(str)){
            return replaceValue;
        }
        return str;
    }

    /*
     * Gets chk val.
     *
     * @param val the val
     * @return the chk val
     */
    public static String getChkVal(String val) {
        String returnVal = "";

        if(val==null) return returnVal;
        val=val.toUpperCase();
        for (int i = 0; i < val.length(); i++) {
            char ch = val.charAt(i);
            if (isHangul(ch)) {
                returnVal += String.valueOf(ch);
            } else {
                if (chkEngNum(ch)) {
                    returnVal += String.valueOf(ch);
                }
            }
        }

        return returnVal;
    }

    /*
     * Chk eng num boolean.
     *
     * @param ch the ch
     * @return the boolean
     */
    public static boolean chkEngNum(char ch) {
        Pattern p = Pattern.compile("[0-9a-zA-Z]");
        Matcher m = p.matcher(String.valueOf(ch));

        if (m.find()) {
            return true;
        } else {
            return false;
        }
    }

    /*
     * Is hangul boolean.
     *
     * @param ch the ch
     * @return the boolean
     */
    public static boolean isHangul(char ch) {
        Character.UnicodeBlock unicodeBlock = Character.UnicodeBlock.of(ch);
        if (Character.UnicodeBlock.HANGUL_SYLLABLES.equals(unicodeBlock)
                || Character.UnicodeBlock.HANGUL_COMPATIBILITY_JAMO.equals(unicodeBlock)
                || Character.UnicodeBlock.HANGUL_JAMO.equals(unicodeBlock)) {
            return true;
        }
        return false;
    }

    /*
     * Get string string.
     *
     * @param str the str
     * @return the string
     */
    public static String getString(String str){
        if(str==null) return "";
        str = str.trim();
        return str;
    }

    /*
     * Obj 2 string string.
     *
     * @param obj the obj
     * @return the string
     */
    public static String obj2String(Object obj) {
        String resultString = "";
        if(obj != null) {
            resultString = String.valueOf(obj);
        }
        return resultString;
    }

    /*
     * Obj 2 string string.
     *
     * @param obj the obj
     * @return the string
     */
    public static String obj3String(Object obj) {
        String resultString = "";
        if(obj != null) {
            if(!String.valueOf(obj).equals("NULL") && !String.valueOf(obj).equals("0") ){
                resultString = String.valueOf(obj);
            }
        }
        return resultString;
    }

    /*
     * Gets string.
     *
     * @param str        the str
     * @param defaultStr the default str
     * @return the string
     */
    public static String getString(String str, String defaultStr) {
        if("".equals(str)||null==str){
            return defaultStr;
        }
        return str;
    }

    /*
     * Gets string.
     *
     * @param str        the str
     * @param defaultStr the default str
     * @return the string
     */
    public static String getString(Object str, String defaultStr) {
        if(null==str){
            return defaultStr;
        }
        return str.toString();
    }

    /*
     * Strip tag string.
     *
     * @param text the text
     * @return the string
     */
    public static String stripTag(String text) {
        if (text != null) return text.replaceAll("<(/)?([a-zA-Z0-9]*)(\\s[a-zA-Z0-9]*=[^>]*)?(\\s)*(/)?>", "");
        return "";
    }

    /*
     * Cut string string.
     *
     * @param str  the str
     * @param len  the len
     * @param tail the tail
     * @return the string
     */
    public static String cutString(String str, int len ,String tail) {
        if(str == null || "".equals(str)) return "";
        if(str.length()<len) return str;

        if(tail!=null && !"".equals(tail)){
            return str.substring(0,len)+tail;
        }else{
            return str.substring(0,len);
        }
    }

    /*
     * Cut string string.
     *
     * @param str the str
     * @param len the len
     * @return the string
     */
    public static String cutString(String str, int len) {
        return cutString(str, len , "...");
    }

    /*
     * Is empty boolean.
     *
     * @param obj the obj
     * @return the boolean
     */
    public static boolean isEmpty(Object obj) {
        return ! isNotEmpty(obj);
    }

    /*
     * Is not empty boolean.
     *
     * @param obj the obj
     * @return the boolean
     */
    public static boolean isNotEmpty(Object obj) {
        boolean result = false;
        if (obj != null) {
            if (obj instanceof String) {
                if (!"".equals(obj)) {
                    result = true;
                }
            }
            else {
                result = true;
            }
        }
        return result;
    }

    public static boolean isNotEqual(Object obj, Object val) {
        boolean result = false;
        if (obj != null
                && val != null) {
            if (obj instanceof String) {
                String key = String.valueOf(obj);
                String value = String.valueOf(val);

                if (key.equals(value)) {
                    result = true;
                }
            }
            else {
                if (obj.equals(val) || obj == val) {
                    result = true;
                }
            }
        }
        return result;
    }

    public static boolean isEqual(Object obj, Object val) {
        return ! isNotEqual(obj, val);
    }

    public static boolean isEmptyValidate(Object obj) {
        return ! isNotEmptyValidate(obj);
    }

    public static boolean isNotEmptyValidate(Object obj) {
        boolean result = false;
        if (obj != null) {
            if (obj instanceof String) {
                String params = ((String) obj).trim();
                if (!"".equals(params)) {
                    result = true;
                }
            } else {
                result = true;
            }
        }
        return result;
    }

    /*
     * clearMemoryBuffer 메모리 clear
     *
     * @param obj *
     */
    public static void clearMemoryBuffer(Object obj) {
        if (obj != null) {
            if (obj instanceof StringBuffer) {
                ((StringBuffer) obj).setLength(0);
            } else if (obj instanceof StringBuilder) {
                ((StringBuilder) obj).setLength(0);
            } else if (obj instanceof Map) {
                ((Map) obj).clear();
            } else if (obj instanceof HashMap) {
                ((HashMap) obj).clear();
            } else if (obj instanceof List) {
                ((List) obj).clear();
            }
        }
    }


    /*
     * phone Number format
     *
     * @param  phone
     * @return String
     */
    public static String phoneFormat(String phone) {
        if (phone == null) {
            return "";
        }
        phone.replaceAll("\\p{Z}", "");
        if (phone.length() == 8) {
            return phone.replaceFirst("^([0-9]{4})([0-9]{4})$", "$1-$2");
        } else if (phone.length() == 12) {
            return phone.replaceFirst("(^[0-9]{4})([0-9]{4})([0-9]{4})$", "$1-$2-$3");
        }
        return phone.replaceFirst("(^02|[0-9]{3})([0-9]{3,4})([0-9]{4})$", "$1-$2-$3");
    }

    public static String extractNumber(String strText) {
        if (strText == null || strText.equals("")) {
            return "";
        }
        return strText.replaceAll("[^0-9]", "");
    }

    public static String korUTF8Encoding(String str) {
        char[] array = str.toCharArray();
        for (char ch : array) {
            if (ch >= '\uAC00' && ch <= '\uD7A3') {
                String targetTxt = String.valueOf(ch);
                try {
                    str = str.replace(targetTxt, URLEncoder.encode(targetTxt, "UTF-8"));
                } catch (UnsupportedEncodingException e) {
                    throw new RuntimeException(e);
                }
            }
        }
        return str;
    }

    public static Float compareFloat(ArrayList<String> list) {
        float maxF = Float.parseFloat(list.get(0));
        for(int i = 0; i < list.size() - 1; i++) {
            if(Float.compare(Float.parseFloat(list.get(i)), Float.parseFloat(list.get(i + 1))) == 0) {
                maxF = Float.parseFloat(list.get(i + 1));
            } else if(Float.compare(Float.parseFloat(list.get(i)), Float.parseFloat(list.get(i + 1))) < 0) {
                maxF = Float.parseFloat(list.get(i + 1));
            } else {
                maxF = Float.parseFloat(list.get(i));
            }
        }
        return maxF;
    }

    public static boolean webIdMatch (String webId) {
        Pattern p = Pattern.compile("^[a-zA-Z][a-zA-Z0-9]{4,11}$");
//		Pattern p = Pattern.compile("/^[a-zA-Z0-9]{4,11}$/");
        Matcher m = p.matcher(webId);

        if(m.find()) {
            return true;
        } else {
            return false;
        }
    }

    public static boolean webPwdMatch (String webPwd) {

        Boolean isNumberSizeFit = Boolean.TRUE;
        Boolean isStringMixedFit = Boolean.TRUE;

//		String webPwd = "abedffhh";
        boolean num = webPwd.matches(".*[0-9].*");
//		System.out.println("num : " + num);
        boolean eng = webPwd.matches(".*[A-Za-z].*");
//		System.out.println("eng : " + eng);
        boolean spe = webPwd.matches(".*[`!@#$%^*/-/=_+~?\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\";\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|{}'<>?///(/)].*");
//		System.out.println("spe : " + spe);
        if(webPwd.length() < 8 || webPwd.length() > 12) {
//			System.out.println("8자리 ~ 12자리 이내로 입력해주세요");
            isNumberSizeFit = Boolean.FALSE;
        }

        if((!num && !eng) || (!eng && !spe) || (!spe && !num)) {
//			System.out.println("영문,숫자, 특수문자 중 2가지 이상을 혼합하여 입력해주세요.");
            isStringMixedFit = Boolean.FALSE;
        }

//		if(isNumberSizeFit || isStringMixedFit) {
//			System.out.println("영문,숫자, 특수문자 중 2가지 이상을 포함한 8 ~ 12글자로 하여야 합니다.");
//		}

        return isNumberSizeFit && isStringMixedFit;
    }

    public static List<String> stringToArray(String str) {
//		String str = "S,E,C";
        String[] strArray = str.split(",");

        List<String> mNewList = Arrays.asList(strArray);
        return mNewList;
    }

    public static String pathRecomb(String path, String fileNm) {
        String pathSplit[] = path.split("/");
        StringBuilder sb = new StringBuilder(10);

        for(int i = 0; i < pathSplit.length - 1; i++) {
            if(i == 0) {
                sb.append(pathSplit[0]);
            } else {
                sb.append("/" + pathSplit[i]);
            }
        }

        sb.append("/" + fileNm);
        String pathRslt = sb.toString();

        return pathRslt;
    }
}

