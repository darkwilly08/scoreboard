import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/custom_text_form_field.dart';
import 'package:anotador/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  final User? user;

  const AddUserScreen({Key? key, this.user}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late UserController _userController;
  final _formKey = GlobalKey<FormState>();
  bool favorite = false;
  String? name;
  String? initial;
  bool editMode = false;

  @override
  void initState() {
    _userController = Provider.of<UserController>(context, listen: false);
    if (widget.user != null) {
      _loadEditableUser();
      editMode = true;
    }
    super.initState();
  }

  void _loadEditableUser() {
    name = widget.user!.name;
    initial = widget.user!.initial;
    favorite = widget.user!.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return _AddUserPhoneView(this);
  }

  void handleCancelBtn() {
    Navigator.pop(context);
  }

  void handleNameChanged(String name) {
    this.name = name;
  }

  void handleInitialChanged(String initial) {
    this.initial = initial;
  }

  void handleFavoriteChanged(bool favorite) {
    setState(() {
      this.favorite = favorite;
    });
  }

  void handleSaveBtn() async {
    if (_formKey.currentState!.validate()) {
      var user = User(name: name!, initial: initial!, favorite: favorite);
      await _userController.AddPlayer(user);
      Navigator.pop(context);
      String snackMsg =
          AppLocalizations.of(context)!.player_added_success(name!);
      final snackBar = SuccessSnackBar(Text(snackMsg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void handleEditBtn() async {
    if (_formKey.currentState!.validate()) {
      var user = User(
        id: widget.user!.id,
        name: name!,
        initial: initial!,
        favorite: favorite,
      );
      await _userController.EditPlayer(user);
      Navigator.pop(context);
      String snackMsg =
          AppLocalizations.of(context)!.player_edited_success(name!);
      final snackBar = SuccessSnackBar(
        Text(snackMsg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void handleDeleteBtn() async {
    await _userController.DeletePlayerById(widget.user!.id!);
    Navigator.pop(context);
    String snackMsg =
        AppLocalizations.of(context)!.player_removed_success(name!);
    final snackBar = SuccessSnackBar(Text(snackMsg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String? _nameValidator(String? val) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.error_field_mandatory;
    }
    return null;
  }

  String? _initialValidator(String? val) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.error_field_mandatory;
    }
    return null;
  }
}

class _AddUserPhoneView extends WidgetView<AddUserScreen, _AddUserScreenState> {
  const _AddUserPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildForm(BuildContext context) {
    return Form(
      key: state._formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            Wrap(
              runSpacing: 20,
              children: [
                CustomTextFormField(
                  labelText: AppLocalizations.of(context)!.input_name,
                  onChanged: state.handleNameChanged,
                  validator: state._nameValidator,
                  initialValue: state.name,
                ),
                CustomTextFormField(
                  labelText: AppLocalizations.of(context)!.input_initial,
                  maxLength: 1,
                  onChanged: state.handleInitialChanged,
                  validator: state._initialValidator,
                  initialValue: state.initial,
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.favorite,
                  ),
                  value: state.favorite,
                  onChanged: state.handleFavoriteChanged,
                )
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomTextButton(
                  onTap: () => state.handleCancelBtn(),
                  text: AppLocalizations.of(context)!.cancel,
                ),
                CustomTextButton(
                  onTap: () {
                    state.editMode
                        ? state.handleEditBtn()
                        : state.handleSaveBtn();
                  },
                  text: AppLocalizations.of(context)!.save,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget? _buildTrailing() {
    if (!state.editMode) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(LineIcons.trash),
          onPressed: () => state.handleDeleteBtn(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = state.editMode
        ? AppLocalizations.of(context)!.edit_player
        : AppLocalizations.of(context)!.add_player;
    return Scaffold(
      appBar: BackHeader(
        title: title,
        trailing: _buildTrailing(),
      ),
      body: Column(
        children: [Expanded(child: _buildForm(context))],
      ),
    );
  }
}
