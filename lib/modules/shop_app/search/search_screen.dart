import 'package:shop_app_api_2/modules/shop_app/search/cubit/cubit.dart';
import 'package:shop_app_api_2/modules/shop_app/search/cubit/states.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/componants/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(AppSize.s20),
                child: Column(
                  children: [
                    defualtFormField(
                        controller: searchController,
                        inputType: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return AppString.enterTextToSearch;
                          }
                        },
                        labelText: AppString.search,
                        prefix: Icons.search,
                        onSubmit: (String text) {
                          SearchCubit.get(context).search(text);
                        }),
                    SizedBox(
                      height: AppSize.s10,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: AppSize.s10,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) =>
                              buildListProduct(SearchCubit.get(context).model!.data!.data![index],
                              context,
                              isOldPrice: false),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context)
                              .model!
                              .data!
                              .data!
                              .length,
                        ),
                      )
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
