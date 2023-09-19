// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/detalleVenta.dart';
import '../models/ventaModel.dart';


class PrintData extends StatelessWidget {
   List<DetalleVenta> venta;
   int index;
   PrintData(this.venta, this.index,{Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PdfPreview(
          build: (format) => _generatePdf(format, venta, index,context),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, List<DetalleVenta> venta, index, a) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    var image = await imageFromAssetBundle("assets/logo/logo.jpg");
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.ClipRRect(
                child: pw.SizedBox(
                  height: 50,
                  width: 50,
                  child: pw.Image(image),
                ),
                      horizontalRadius: 25,
                      verticalRadius: 25
                    ),

                    pw.SizedBox(width: 20),
                    pw.Text(Venta.ventas[index].nombre.toString() + (Venta.ventas[index].nombreDelNegocio.toString().isNotEmpty || Venta.ventas[index].alias.toString().isNotEmpty ? " (" : "") + Venta.ventas[index].nombreDelNegocio.toString() + ((Venta.ventas[index].alias.toString().isNotEmpty ? ("-> " + Venta.ventas[index].alias.toString()) : "") + ((Venta.ventas[index].nombreDelNegocio.toString().isNotEmpty || Venta.ventas[index].alias.toString().isNotEmpty) ? ")" : "")), style: pw.TextStyle(fontSize: 23)),
                  ]
                )
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                columnWidths: <int, pw.TableColumnWidth>{
                  0: pw.FlexColumnWidth(4),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(2),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: venta.map((e){
                  return pw.TableRow(
                      children: [
                        pw.Text("PRODUCTO", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("PRECIO", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("CANTIDAD", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ]
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                columnWidths: <int, pw.TableColumnWidth>{
                  0: pw.FlexColumnWidth(4),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(2),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: venta.map((e){
                  return pw.TableRow(
                    children: [
                      pw.Text(e.nombreDelProducto.toString(), style: pw.TextStyle(fontSize: 12)),
                      pw.Text("\$" + e.precioVendido.toString()),
                      pw.Text(e.cantidad.toString()),
                      pw.Text("\$" +e.total.toString()),
                    ]
                  );
                }).toList(),
              ),


              pw.Divider(thickness: 0.01),
              pw.Table(
                columnWidths: <int, pw.TableColumnWidth>{
                  0: pw.FlexColumnWidth(4),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(2),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: venta.map((e){
                  return pw.TableRow(
                      children: [
                        pw.Text("", style: pw.TextStyle(fontSize: 12)),
                        pw.Text(""),
                        pw.Text(""),
                        pw.Text("\$" +Venta.ventas[index].total.toString()),
                      ]
                  );
                }).toList(),
              ),
              pw.Spacer(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}