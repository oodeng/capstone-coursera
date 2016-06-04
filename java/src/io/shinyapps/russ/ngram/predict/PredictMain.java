package io.shinyapps.russ.ngram.predict;

import java.util.HashMap;
import java.util.Map;

public class PredictMain implements Predictor {

	private static Map<String, Predictor> _predictors = new HashMap<String, Predictor>();
	
	static {
		_predictors.put("default", new Predictor() {
			@Override
			public String predict(String inputText) {
				return "Java";
			}
		});
	}
	
	public static void main(String[] args) {
		System.out.println(predict(args[0], args[1]));
	}
	
	public static String predict(String predictor, String inputText) {
		return _predictors.get(predictor).predict(inputText);
	}
	
	private final Predictor _predictor;
	public PredictMain(String predictor) {
		_predictor = _predictors.get(predictor);
	}
	public String predict(String inputText) {
		return _predictor.predict(inputText);
	}
}
