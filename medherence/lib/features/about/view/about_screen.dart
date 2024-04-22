import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../widgets/about_widget.dart';

class AboutScreenView extends StatelessWidget {
  const AboutScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(
            fontSize: SizeMg.text(25),
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardView()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeMg.width(15),
            right: SizeMg.width(15),
            top: SizeMg.height(44),
          ),
          child: Column(
            children: [
              AboutWidget(
                  title: 'App Version',
                  subtitle: 'Report any difficulty you are facing',
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: () {
                    // Navigate to settings screen
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImageUtils.appVersionIcon,
                      height: SizeMg.height(24),
                      width: SizeMg.width(24),
                    ),
                  )),
              SizedBox(
                height: SizeMg.height(15),
              ),
              AboutWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'Privacy Policy',
                subtitle: 'Data collection, usage and protection',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      ImageUtils.privacyPolicyIcon,
                      height: SizeMg.height(24),
                      width: SizeMg.width(24),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              AboutWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'About Medherence',
                subtitle: 'Learn more about Medherence Ltd.',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    ImageUtils.medherenceAppIcon,
                    height: SizeMg.height(24),
                    width: SizeMg.width(24),
                  ),
                ),
              ),
              SizedBox(
                height: SizeMg.height(15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Align(
//                     alignment: AlignmentDirectional(0, -1),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
//                       child: FlutterFlowDropDown<String>(
//                         controller: _model.party1juridictionValueController ??=
//                             FormFieldController<String>(null),
//                         options: FFAppState().countries,
//                         onChanged: (val) =>
//                             setState(() => _model.party1juridictionValue = val),
//                         width: double.infinity,
//                         height: 50,
//                         searchHintTextStyle:
//                             FlutterFlowTheme.of(context).labelMedium.override(
//                                   fontFamily: 'Readex Pro',
//                                   letterSpacing: 0,
//                                 ),
//                         searchTextStyle:
//                             FlutterFlowTheme.of(context).bodyMedium.override(
//                                   fontFamily: 'Readex Pro',
//                                   letterSpacing: 0,
//                                 ),
//                         textStyle:
//                             FlutterFlowTheme.of(context).bodyMedium.override(
//                                   fontFamily: 'Readex Pro',
//                                   letterSpacing: 0,
//                                 ),
//                         hintText: 'Select Jurisdiction',
//                         searchHintText: 'Search for the juridiction...',
//                         icon: Icon(
//                           Icons.keyboard_arrow_down_rounded,
//                           color: FlutterFlowTheme.of(context).secondaryText,
//                           size: 24,
//                         ),
//                         fillColor: FlutterFlowTheme.of(context).alternate,
//                         elevation: 2,
//                         borderColor: FlutterFlowTheme.of(context).alternate,
//                         borderWidth: 2,
//                         borderRadius: 8,
//                         margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
//                         hidesUnderline: true,
//                         isSearchable: true,
//                         isMultiSelect: false,
//                       ),
//                     ),
//                   ),