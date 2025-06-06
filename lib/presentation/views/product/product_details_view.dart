import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/core/constant/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/price_tag.dart';
import '../../../../../domain/entities/product/product.dart';
import '../../../core/router/app_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/input_form_button.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  late PriceTag _selectedPriceTag;

  @override
  void initState() {
    _selectedPriceTag = widget.product.priceTags.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.8),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.message, color: colorScheme.onSurface),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: colorScheme.onSurface),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: kPaddingMedium),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Hero(
                        tag: widget.product.id,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.surface.withOpacity(0.25),
                                  BlendMode.softLight,
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: widget.product.images.length,
                effect: ScrollingDotsEffect(
                  dotColor: colorScheme.surfaceVariant,
                  maxVisibleDots: 7,
                  activeDotColor: colorScheme.primary,
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotScale: 1.1,
                  spacing: 6,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 14, top: 20, bottom: 4),
            child: Text(
              widget.product.name,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Wrap(
              children: widget.product.priceTags
                  .map((priceTag) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPriceTag = priceTag;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: _selectedPriceTag.id == priceTag.id ? 2.0 : 1.0,
                              color: _selectedPriceTag.id == priceTag.id
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 4),
                          child: Column(
                            children: [
                              Text(
                                priceTag.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                priceTag.price.toString(),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 10,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Text(
              widget.product.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: colorScheme.primary,
        height: 80 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          top: 10,
          left: 20,
          right: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '\$${_selectedPriceTag.price}',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: InputFormButton(
                color: colorScheme.onSurface,
                onClick: () {
                  context.read<CartBloc>().add(AddProduct(
                      cartItem: CartItem(
                          product: widget.product,
                          priceTag: _selectedPriceTag)));
                  Navigator.pop(context);
                },
                titleText: "Add to Cart",
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 90,
              child: InputFormButton(
                color: colorScheme.onSurface,
                onClick: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.orderCheckout,
                    arguments: [
                      CartItem(
                        product: widget.product,
                        priceTag: _selectedPriceTag,
                      )
                    ],
                  );
                },
                titleText: "Buy",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
