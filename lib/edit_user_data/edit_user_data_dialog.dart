import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning_poker_open/edit_user_data/bloc/edit_user_data_bloc.dart';
import 'package:planning_poker_open/shared/presentation/widgets/basic_separation_space.dart';
import 'package:planning_poker_open/shared/styles/basic_styles.dart';
import 'package:planning_poker_open/user_authentication/bloc/authentication_bloc.dart';
import 'package:planning_poker_open/user_authentication/models/user_app.dart';

class EditUserDataDialog extends StatefulWidget {
  const EditUserDataDialog({super.key, required this.actualUserData});

  final UserApp actualUserData;

  @override
  State<EditUserDataDialog> createState() => _EditUserDataDialogState();
}

class _EditUserDataDialogState extends State<EditUserDataDialog> {
  final TextEditingController usernameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.actualUserData.username;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditUserDataBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<EditUserDataBloc, EditUserDataState>(
            listener: (context, state) {
              if (state is EditUserDataLoading) {
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }

              if (state is EditUserDataSuccess) {
                context.read<AuthenticationBloc>().add(
                      AuthenticationUpdateUserData(
                        userAppNewData: state.userAppNewData,
                      ),
                    );
                Navigator.of(context).pop();
              }
            },
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: BasicStyles.horizontalPadding,
                  vertical: BasicStyles.verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SelectableText(
                      'Edit your display information',
                      style: BasicStyles.titleStyle,
                    ),
                    const BasicSeparationSpace.vertical(
                      multiplier: 2,
                    ),
                    TextField(
                      controller: usernameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Your display name',
                      ),
                    ),
                    const BasicSeparationSpace.vertical(
                      multiplier: 2,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        context.read<EditUserDataBloc>().add(
                              EditUserData(
                                username: usernameController.text,
                              ),
                            );
                      },
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
