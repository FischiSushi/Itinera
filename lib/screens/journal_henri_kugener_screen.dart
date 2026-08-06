import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import 'package:itinera/design/palette.dart';

const _cheminJournalHenriKugener = 'assets/henri_kugener/limited_edition.pdf';

class JournalHenriKugenerScreen extends StatefulWidget {
  const JournalHenriKugenerScreen({super.key});

  @override
  State<JournalHenriKugenerScreen> createState() =>
      _JournalHenriKugenerScreenState();
}

class _JournalHenriKugenerScreenState extends State<JournalHenriKugenerScreen> {
  late final PdfControllerPinch _controleur;

  @override
  void initState() {
    super.initState();
    _controleur = PdfControllerPinch(
      document: PdfDocument.openAsset(_cheminJournalHenriKugener),
    );
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Lunae, Annae Devaeque'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: PdfViewPinch(controller: _controleur),
      ),
    );
  }
}
