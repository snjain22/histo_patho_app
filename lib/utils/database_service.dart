import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:histo_patho_app/unused/slide.dart';

const String SLIDES_COLLECTION_REF = "pathology_slides";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _slidesRef;

  DatabaseService() {
    _slidesRef = _firestore.collection(SLIDES_COLLECTION_REF).withConverter<Slide>(
      fromFirestore: (snapshots, _) => Slide.fromMap(snapshots.data()!, snapshots.id),
      toFirestore: (slide, _) => slide.toMap(),
    );
  }

  Stream<QuerySnapshot<Slide>> getSlides() {
    return _slidesRef.snapshots();
  }

  Future<void> addSlide(Slide slide) async {
    DocumentReference docRef = await _slidesRef.add(slide);
    slide.id = docRef.id;
  }

  Future<void> updateSlide(String slideId, Slide slide) async {
    await _slidesRef.doc(slideId).update(slide.toMap());
  }

  Future<void> deleteSlide(String slideId) async {
    await _slidesRef.doc(slideId).delete();
  }

  Future<Object?> getSlideById(String slideId) async {
    DocumentSnapshot<Object?> doc = await _slidesRef.doc(slideId).get();
    return doc.data();
  }

  Stream<QuerySnapshot<Slide>> getSlidesBySystem(String systemName) {
    return _slidesRef.where('systemName', isEqualTo: systemName).snapshots();
  }
}