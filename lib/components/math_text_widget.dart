import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const MathTextWidget({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse teks untuk menemukan ekspresi LaTeX yang dibungkus dengan $$ atau $
    List<InlineSpan> spans = [];
    RegExp exp = RegExp(r'(\$\$(.*?)\$\$|\$(.*?)\$)', dotAll: true);
    
    String remaining = text;
    int lastMatchEnd = 0;
    
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    
    for (var match in matches) {
      // Tambahkan teks sebelum ekspresi LaTeX
      if (match.start > lastMatchEnd) {
        String textBefore = text.substring(lastMatchEnd, match.start);
        spans.add(TextSpan(text: textBefore, style: textStyle));
      }
      
      // Ekstrak ekspresi LaTeX (hapus tanda $ atau $$)
      String latexExp;
      bool isDisplayMode = false;
      
      if (match.group(2) != null) {
        // Untuk ekspresi $$...$$
        latexExp = match.group(2)!;
        isDisplayMode = true;
      } else {
        // Untuk ekspresi $...$
        latexExp = match.group(3)!;
        isDisplayMode = false;
      }
      
      // Tambahkan widget Math ke dalam spans
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          latexExp,
          textStyle: textStyle,
          // displayMode: isDisplayMode,leb
        ),
      ));
      
      lastMatchEnd = match.end;
    }
    
    // Tambahkan sisa teks (jika ada)
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: textStyle,
      ));
    }
    
    return RichText(
      text: TextSpan(
        style: textStyle ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}